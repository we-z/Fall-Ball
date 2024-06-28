//
//  SubscriptionOptions.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 6/11/24.
//

import SwiftUI
import StoreKit


struct SubscriptionOptions: View {
    @Binding var bundle: CurrencyBundle
    @State var subscriptionDeal = BundleSubscription(image: "", coins: 0, cost: "", subscriptionID: "", bundleID: "")
    @StateObject var storeKit = StoreKitManager()
    @State var isProcessingPurchase = false
    @State var subscriptionPlans: [BundleSubscription] = [
        BundleSubscription(image: "small-pile", coins: 35, cost: "$4.99", subscriptionID: "35boinssubscription", bundleID: "25boins"),
        BundleSubscription(image: "box-pile", coins: 75, cost: "$9.99", subscriptionID: "75boinssubscription", bundleID: "55boins"),
        BundleSubscription(image: "bucket-pile", coins: 200, cost: "$19.99", subscriptionID: "200boinssubscription", bundleID: "125boins"),
        BundleSubscription(image: "crate-pile", coins: 500, cost: "$49.99", subscriptionID: "500boinssubscription", bundleID: "350boins"),
        BundleSubscription(image: "big-pile", coins: 1000, cost: "$99.99", subscriptionID: "1000boinssubscription", bundleID: "800boins")
    ]
    @ObservedObject var userPersistedData = UserPersistedData()
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var appModel = AppModel.sharedAppModel
    
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
        
    @MainActor
    func buyBoins(bundle: CurrencyBundle) async {
        do {
            if (try await storeKit.purchase(bundleID: bundle.bundleID)) != nil{
                DispatchQueue.main.async {
                    userPersistedData.incrementBalance(amount: bundle.coins)
                }
                dismiss()
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        appModel.grabbingBoins = false
        isProcessingPurchase = false
    }
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            VStack {
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                Spacer()
                Image(bundle.image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .customShadow()
                    .padding(.leading)
                    .animatedOffset(speed: 1)
                Spacer()
                Text("Subscribe and Get More")
                    .font(.system(size: 27))
                    .bold()
                    .italic()
                    .customTextStroke(width:2.1)
                    .padding()
                Button{
                    isProcessingPurchase = true
                    Task {
                        await buySubscription()
                    }
                } label: {
                    HStack{
                        Spacer()
                        BoinsView()
                        Text(String(subscriptionDeal.coins)+" / month")
                            .bold()
                            .italic()
                            .font(.title)
                            .customTextStroke(width: 1.8)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(.yellow)
                    .overlay{
                        RoundedRectangle(cornerRadius: 27)
                            .stroke(Color.black, lineWidth: 3)
                            .padding(1)
                    }
                    .cornerRadius(27)
                    .padding(.horizontal, 30)
                    .padding(.bottom, idiom == .pad || UIDevice.isOldDevice ? 30 : 0)
                }
                .buttonStyle(.roundedAndShadow9)
                Button{
                    impactHeavy.impactOccurred()
                    isProcessingPurchase = true
                    Task {
                        await buyBoins(bundle: bundle)
                    }
                } label: {
                    HStack{
                        Spacer()
                        BoinsView()
                            .scaleEffect(0.6)
                            .offset(x: 9, y:6)
                        Text(String(bundle.coins)+" one time")
                            .bold()
                            .italic()
                            .font(.system(size: 21))
                            .customTextStroke(width: 1.5)
                            .padding(.top)
                        Spacer()
                    }
                    .offset(x: -6)
                    .padding(.bottom, idiom == .pad || UIDevice.isOldDevice ? 30 : 0)
                }
            }
            if isProcessingPurchase {
                Color.gray.opacity(0.3) // Gray out the background
                    .edgesIgnoringSafeArea(.all)
                HangTight()
            
            }
        }
        .allowsHitTesting(!isProcessingPurchase)
        .onAppear{
            subscriptionDeal = subscriptionPlans.first(where: {$0.bundleID == bundle.bundleID})!
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
    }
    
    let openToday = NSDate().formatted
    
    func buySubscription() async {
        do {
            if try await storeKit.purchase(bundleID: subscriptionDeal.subscriptionID) != nil {
                print("Boin Subscription succesful")
                userPersistedData.purchasedSubscriptionAmount = subscriptionDeal.coins
                userPersistedData.incrementBalance(amount: subscriptionDeal.coins)
                userPersistedData.updateLastRenewal(date: openToday)
                dismiss()
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for \(subscriptionDeal.bundleID): \(error)")
        }
        isProcessingPurchase = false
    }
}

struct BundleSubscription: Hashable {
    let image: String
    let coins: Int // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let cost: String
    let subscriptionID: String
    let bundleID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(bundleID)
    }

    static func ==(lhs: BundleSubscription, rhs: BundleSubscription) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.bundleID == rhs.bundleID
    }
}
