//
//  CurrencyPageView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/21/23.
//

import SwiftUI

struct CurrencyPageView: View {
    @Environment(\.dismiss) private var dismiss
    @State var isProcessingPurchase = false
    @State var showSubscriptionOptions = false
    @ObservedObject var appModel = AppModel.sharedAppModel
    @State var boinBundles: [BoinBundles] = [
        BoinBundles(image: "small-pile", amount: 25, subscriptionAmount: 35, cost: "$4.99", subscriptionID: "35boinssubscription", bundleID: "25boins"),
        BoinBundles(image: "box-pile", amount: 55, subscriptionAmount: 75, cost: "$9.99", subscriptionID: "75boinssubscription", bundleID: "55boins"),
        BoinBundles(image: "bucket-pile", amount: 125, subscriptionAmount: 200, cost: "$19.99", subscriptionID: "200boinssubscription", bundleID: "125boins"),
        BoinBundles(image: "crate-pile", amount: 350, subscriptionAmount: 500, cost: "$49.99", subscriptionID: "500boinssubscription", bundleID: "350boins"),
        BoinBundles(image: "big-pile", amount: 800, subscriptionAmount: 1000, cost: "$99.99", subscriptionID: "1000boinssubscription", bundleID: "800boins")
    ]
    @State var selectedBundle = CurrencyBundle(image: "", coins: 0, cost: "", bundleID: "")
    @StateObject var storeKit = StoreKitManager()
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @ObservedObject var userPersistedData = UserPersistedData()
    @State private var showManageSubscriptions = false
    @State private var showBoinInfo = false
    @State var errorTitle = ""
    @State var isShowingError: Bool = false
    
    @MainActor
    func buyBoins(bundle: BoinBundles) async {
        do {
            if (try await storeKit.purchase(bundleID: bundle.bundleID)) != nil{
                DispatchQueue.main.async {
                    userPersistedData.incrementBalance(amount: bundle.amount)
                }
                dismiss()
            }
        } catch {
            print("Purchase failed: \(error)")
        }
        appModel.grabbingBoins = false
        isProcessingPurchase = false
    }
    
    let openToday = NSDate().formatted
    
    func buySubscription(bundle: BoinBundles) async {
        do {
            if try await storeKit.purchase(bundleID: bundle.subscriptionID) != nil {
                print("Boin Subscription succesful")
                userPersistedData.purchasedSubscriptionAmount = bundle.subscriptionAmount
                userPersistedData.incrementBalance(amount: bundle.subscriptionAmount)
                userPersistedData.updateLastRenewal(date: openToday)
                dismiss()
            }
        } catch StoreError.failedVerification {
            errorTitle = "Your purchase could not be verified by the App Store."
            isShowingError = true
        } catch {
            print("Failed purchase for subscription")
        }
        isProcessingPurchase = false
    }
    
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                    Text("💰🤩 Boins 🤩💰")
                        .customTextStroke(width: 1.8)
                        .italic()
                        .bold()
                        .font(.largeTitle)
                        .scaleEffect(1.1)
                    ScrollView(showsIndicators: false){
                        ForEach(0..<boinBundles.count, id: \.self) { index in
                                let bundle = boinBundles[index]
                            HStack{
                                VStack{
                                    Image(boinBundles[index].image)
                                        .resizable()
                                        .frame(width: 75, height: 75)
                                        .customTextStroke()
                                    Text(boinBundles[index].cost)
                                        .font(.system(size: 21))
                                        .lineLimit(1)
                                        .italic()
                                        .bold()
                                        .customTextStroke(width: 1.5)

                                }
                                .offset(y: 9)
                                .frame(width: 90)
                                Spacer()
                                VStack {
                                    if index == 0 {
                                        Text("One Time ☝️")
                                            .customTextStroke(width: 1.8)
                                        .italic()
                                        .bold()
                                        .font(.system(size: 18))
                                        .padding(.top, 3)
                                    }
                                    Button {
                                        isProcessingPurchase = true
                                        Task {
                                            await buyBoins(bundle: bundle)
                                        }
                                    } label: {
                                        Rectangle()
                                            .fill(.yellow)
                                            .cornerRadius(21)
                                            .frame(width: 120, height: 120)
                                            .overlay{
                                                HStack{
                                                    BoinsView()
                                                    Text(String(boinBundles[index].amount))
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 21))
                                                        .customTextStroke(width:1.5)
                                                }
                                            }
                                            .mask{
                                                RoundedRectangle(cornerRadius: 21)
                                            }
                                            .overlay{
                                                RoundedRectangle(cornerRadius: 21)
                                                    .stroke(Color.black, lineWidth: 4)
                                                    .frame(height: 120)
                                                    .padding(1)
                                            }
                                            .accentColor(.black)
                                            .padding(.vertical, 9)
                                    }
                                    .buttonStyle(.roundedAndShadow6)
                                }
                                Spacer()
                                VStack {
                                    if index == 0 {
                                        Text("Subscribe 📆")
                                            .customTextStroke(width: 1.8)
                                        .italic()
                                        .bold()
                                        .font(.system(size: 18))
                                        .padding(.top, 3)
                                    }
                                    Button {
                                        isProcessingPurchase = true
                                        Task {
                                            await buySubscription(bundle: bundle)
                                        }
                                    } label: {
                                        Rectangle()
                                            .overlay(.green)
                                            .cornerRadius(21)
                                            .frame(width: 120, height: 120)
                                            .overlay{
                                                VStack{
                                                    HStack{
                                                        BoinsView()
                                                        Text(String(boinBundles[index].subscriptionAmount))
                                                            .bold()
                                                            .italic()
                                                            .font(.system(size: 21))
                                                            .customTextStroke(width:1.5)
                                                    }
                                                    Text("/ month")
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 21))
                                                        .customTextStroke(width:1.5)
                                                }
                                                if index == 1 {
                                                    HStack{
                                                        Text("MOST POPULAR")
                                                            .foregroundColor(.black)
                                                            .bold()
                                                            .italic()
                                                            .font(.system(size: 12))
                                                            .padding(.horizontal, 9)
                                                            .padding(.top, 6)
                                                    }
                                                    .background{
                                                        Color.red
                                                    }
                                                    .roundedCorner(0, corners: [.bottomLeft, .bottomRight])
                                                    .customTextStroke(width: 1.5)
                                                    .offset(y: -51)
                                                }
                                                if index == 4 {
                                                    HStack{
                                                        Text("BEST DEAL!")
                                                            .foregroundColor(.black)
                                                            .bold()
                                                            .italic()
                                                            .font(.system(size: 12))
                                                            .padding(.horizontal, 21)
                                                            .padding(.top, 6)
                                                    }
                                                    .background{
                                                        Color.blue
                                                    }
                                                    .roundedCorner(0, corners: [.bottomLeft, .bottomRight])
                                                    .customTextStroke(width: 1.5)
                                                    .offset(y: -51)
                                                }
                                                
                                            }
                                            .mask{
                                                RoundedRectangle(cornerRadius: 21)
                                            }
                                            .overlay{
                                                RoundedRectangle(cornerRadius: 21)
                                                    .stroke(Color.black, lineWidth: 4)
                                                    .frame(height: 120)
                                                    .padding(1)
                                            }
                                            .accentColor(.black)
                                            .padding(.horizontal, 12)
                                            .padding(.vertical, 9)
                                    }
                                    .buttonStyle(.roundedAndShadow6)
                                }
                                Spacer()
                            }
                        }
                        Button{
                            impactHeavy.impactOccurred()
                            showManageSubscriptions = true
                        } label: {
                            Text("Subscriptions 📆")
                                .font(.system(size: 30))
                                .customTextStroke(width: 2)
                                .bold()
                                .italic()
                                .padding()
                        }
                        Button{
                            impactHeavy.impactOccurred()
                            showBoinInfo = true
                        } label: {
                            Text("Boins? 🤔")
                                .font(.system(size: 30))
                                .customTextStroke(width: 2)
                                .bold()
                                .italic()
                                .padding(.bottom)
                        }
                    }
                    .padding(.leading, 9)
            }
            if isProcessingPurchase {
                Color.gray.opacity(0.3) // Gray out the background
                    .edgesIgnoringSafeArea(.all)
                HangTight()
            
            }
        }
        .alert(isPresented: $isShowingError, content: {
            Alert(title: Text(errorTitle), message: nil, dismissButton: .default(Text("Okay")))
        })
        .allowsHitTesting(!isProcessingPurchase)
        .sheet(isPresented: self.$showSubscriptionOptions) {
            SubscriptionOptions(bundle: $selectedBundle)
                .presentationDetents([.height(550)])
        }
        .sheet(isPresented: self.$showBoinInfo) {
            BoinInfoView()
                .presentationDetents([.height(300)])
        }
        .manageSubscriptionsSheet(isPresented: $showManageSubscriptions)
    }
}

struct CurrencyBundle: Hashable {
    let image: String
    let coins: Int // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let cost: String
    let bundleID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(bundleID)
    }

    static func ==(lhs: CurrencyBundle, rhs: CurrencyBundle) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.bundleID == rhs.bundleID
    }
}

struct BoinBundles: Hashable {
    let image: String
    let amount: Int
    let subscriptionAmount: Int
    let cost: String
    let subscriptionID: String
    let bundleID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(bundleID)
    }

    static func ==(lhs: BoinBundles, rhs: BoinBundles) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.bundleID == rhs.bundleID
    }
}

#Preview {
    CurrencyPageView()
}
