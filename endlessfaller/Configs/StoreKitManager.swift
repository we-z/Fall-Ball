//
//  StoreKitManager.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/17/23.
//


import Foundation
import StoreKit
import FirebaseAnalytics

public enum StoreError: Error {
    case failedVerification
}

class StoreKitManager: ObservableObject {
    // if there are multiple product types - create multiple variable for each .consumable, .nonconsumable, .autoRenewable, .nonRenewable.
    @Published var storeProducts: [Product] = []
    
    var updateListenerTask: Task<Void, Error>? = nil
    
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
        
        //Start a transaction listener as close to the app launch as possible so you don't miss any transaction
        updateListenerTask = listenForTransactions()
        
        //create async operation
        Task {
            await requestProducts()
            
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
                    
                    //the transaction is verified, deliver the content to the user
                    
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
                
                //always finish a transaction - performance
                await transaction.finish()
            
                Analytics.logTransaction(transaction)
                
                return transaction
                
            case .userCancelled, .pending:
                return nil
            default:
                return nil
        }
        
    }
    
}

// StoreKitManager.swift

extension Product {
    func matchesBundleID(_ bundleID: String) -> Bool {
        return id == bundleID
    }
}

