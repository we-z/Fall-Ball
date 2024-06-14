//
//  StoreKitManager.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/17/23.
//


import Foundation
import StoreKit

typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
}

class StoreKitManager: ObservableObject {
    // if there are multiple product types - create multiple variable for each .consumable, .nonconsumable, .autoRenewable, .nonRenewable.
    @Published var storeProducts: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    @Published private(set) var subscriptions: [Product]
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    
    //maintain a plist of products
    private let productDict: [String : String]
    init() {
        //check the path for the plist
        if let plistPath = Bundle.main.path(forResource: "ProductList", ofType: "plist"),
           //get the list of products
           let plist = FileManager.default.contents(atPath: plistPath) {
            productDict = (try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String : String]) ?? [:]
        } else {
            productDict = [:]
        }
        
        subscriptions = []
        
        //Start a transaction listener as close to the app launch as possible so you don't miss any transaction
        updateListenerTask = listenForTransactions()
        
        //create async operation
        Task {
            await requestProducts()
            
            //Deliver products that the customer purchases.
            await updateCustomerProductStatus()
        }
    }
    
    //denit transaction listener on exit or app close
    deinit {
        updateListenerTask?.cancel()
    }
    
    //listen for transactions - start this early in the app
    func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            //iterate through any transactions that don't come from a direct call to 'purchase()'
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    
                    //Deliver products to the user.
                    await self.updateCustomerProductStatus()
                    
                    //Always finish a transaction
                    await transaction.finish()
                } catch {
                    //storekit has a transaction that fails verification, don't delvier content to the user
                    print("Transaction failed verification")
                }
            }
        }
    }
    
    // request the products in the background
    @MainActor
    func requestProducts() async {
        do {
            //using the Product static method products to retrieve the list of products
            storeProducts = try await Product.products(for: productDict.values)
            
            var newSubscriptions: [Product] = []
            
            for product in storeProducts {
                switch product.type {
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    //Ignore this product.
                    print("Unknown product")
                }
            }
            
            subscriptions = newSubscriptions
            
            // iterate the "type" if there are multiple product types.
        } catch {
            print("Failed - error retrieving products \(error)")
        }
    }
    
    
    //Generics - check the verificationResults
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        //check if JWS passes the StoreKit verification
        switch result {
        case .unverified:
            //failed verificaiton
            throw StoreError.failedVerification
        case .verified(let signedType):
            //the result is verified, return the unwrapped value
            return signedType
        }
    }
    
    
    // call the product purchase and returns an optional transaction
    func purchase(bundleID: String) async throws -> Transaction? {
        // Find the product that matches the characterID
        guard let product = storeProducts.first(where: { $0.matchesBundleID(bundleID) }) else {
            print("Product not found for bundleID: \(bundleID)")
            return nil
        }
        //make a purchase request - optional parameters available
        let result = try await product.purchase()
        
        await MainActor.run {
            AppModel.sharedAppModel.grabbingBoins = true
        }
        
        // check the results
        switch result {
            case .success(let verificationResult):
                //Transaction will be verified for automatically using JWT(jwsRepresentation) - we can check the result
                let transaction = try checkVerified(verificationResult)
                
                //the transaction is verified, deliver the content to the user
                await updateCustomerProductStatus()
                
                //always finish a transaction - performance
                await transaction.finish()
                
                return transaction
                
            case .userCancelled, .pending:
                return nil
            default:
                return nil
        }
        
    }
    
    @MainActor
    func updateCustomerProductStatus() async {
        var purchasedSubscriptions: [Product] = []

        //Iterate through all of the user's purchased products.
        for await result in Transaction.currentEntitlements {
            do {
                //Check whether the transaction is verified. If it isn’t, catch `failedVerification` error.
                let transaction = try checkVerified(result)

                //Check the `productType` of the transaction and get the corresponding product from the store.
                switch transaction.productType {

                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }) {
                        purchasedSubscriptions.append(subscription)
                    }
                default:
                    break
                }
            } catch {
                print()
            }
        }


        //Update the store information with auto-renewable subscription products.
        self.purchasedSubscriptions = purchasedSubscriptions

        //Check the `subscriptionGroupStatus` to learn the auto-renewable subscription state to determine whether the customer
        //is new (never subscribed), active, or inactive (expired subscription). This app has only one subscription
        //group, so products in the subscriptions array all belong to the same group. The statuses that
        //`product.subscription.status` returns apply to the entire subscription group.
        subscriptionGroupStatus = try? await subscriptions.first?.subscription?.status.first?.state
    }
    
}

// StoreKitManager.swift

extension Product {
    func matchesBundleID(_ bundleID: String) -> Bool {
        return id == bundleID
    }
}

