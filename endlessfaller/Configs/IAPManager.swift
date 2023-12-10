//
//  IAPManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 12/4/23.
//

import Foundation
import StoreKit

/// Represents In App Purchase Manager
public final class IAPManager: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    /// Shared Instance
    static let shared = IAPManager()
    
    var products = [SKProduct]()
    
    private var completion: ((Int) -> Void)?
    
    enum Bundles: String, CaseIterable {
        case boins_25
        case boins_55
        case boins_125
        case boins_350
        
        var count: Int {
            switch self {
                case .boins_25:
                    return 25
                case .boins_55:
                    return 55
                case .boins_125:
                    return 125
                case .boins_350:
                    return 350
            }
        }
    }
    

    /// Fetch store kit products from Apple
    /// Note: In dev environment please set up local store kit configuration
    func fetchProducts() {
        let request = SKProductsRequest(
            productIdentifiers: Set(Bundles.allCases.compactMap({ $0.rawValue }))
        )
        request.delegate = self
        request.start()
    }
    
    public func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        self.products = response.products
    }

    func purchase(product: Bundles, completion: @escaping ((Int) -> Void)) {
        print("purchase function called")
        guard SKPaymentQueue.canMakePayments() else {
            //completion(.failure(SFKTransactionError.cannotMakePurchases))
            return
        }
        print("canMakePayments")
        guard let storeKitProduct = products.first(where: { $0.productIdentifier == product.rawValue }) else {
            print(products)
            print("product not found")
            return
        }
        print("product found")
        self.completion = completion
        
        let paymentRequest = SKPayment(product: storeKitProduct)
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().add(paymentRequest)
        
//        self.transactingProduct = product
//        self.completion = completion
//
//        whenAppStoreProductsReady {
//            DispatchQueue.main.async {
//                let payment = SKPayment(product: appStoreProduct)
//                SKPaymentQueue.default().add(payment)
//            }
//        }
    }

    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: - Private

//    private func whenAppStoreProductsReady(handler: @escaping (() -> Void)) {
//        guard appStoreProducts.isEmpty else {
//            handler()
//            return
//        }
//        whenReadyHandlers.append(handler)
//    }
//
//    // MARK: - Store Kit Interface
//
//    public func request(_ request: SKRequest, didFailWithError error: Error) {
//        guard request is SKProductsRequest else {
//            return
//        }
//        appStoreProducts = []
//    }

    public func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach {
            switch $0.transactionState {
            case .purchasing:
                break
            case .purchased:
                if let product = Bundles(rawValue: $0.payment.productIdentifier) {
                    completion?(product.count)
                }
                SKPaymentQueue.default().finishTransaction($0)
                SKPaymentQueue.default().remove(self)
            case .failed:
//                completion?(.failure(SFKTransactionError.transactionFailed))
//                SKPaymentQueue.default().finishTransaction($0)
                break
            case .restored:
//                SKPaymentQueue.default().finishTransaction($0)
                break
            case .deferred:
//                SKPaymentQueue.default().finishTransaction($0)
                break
            @unknown default:
                break
            }
        }
    }

//    public func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
//        return true
//    }
}
