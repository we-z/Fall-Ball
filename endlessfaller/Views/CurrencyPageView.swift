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
    @State var bundles: [CurrencyBundle] = [
        CurrencyBundle(image: "small-pile", coins: 25, cost: "$4.99", bundleID: "25boins"),
        CurrencyBundle(image: "box-pile", coins: 55, cost: "$9.99", bundleID: "55boins"),
        CurrencyBundle(image: "bucket-pile", coins: 125, cost: "$19.99", bundleID: "125boins"),
        CurrencyBundle(image: "crate-pile", coins: 350, cost: "$49.99", bundleID: "350boins"),
        CurrencyBundle(image: "big-pile", coins: 800, cost: "$99.99", bundleID: "800boins")
    ]
    @State var selectedBundle = CurrencyBundle(image: "", coins: 0, cost: "", bundleID: "")
    @StateObject var storeKit = StoreKitManager()
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @ObservedObject var userPersistedData = UserPersistedData()
    @State private var showManageSubscriptions = false
    
    
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
                        ForEach(0..<bundles.count, id: \.self) { index in
                                let bundle = bundles[index]
                                Button {
//                                    selectedBundle = CurrencyBundle(image: bundle.image, coins: bundle.coins, cost: bundle.cost, bundleID: bundle.bundleID)
//                                    if storeKit.purchasedSubscriptions.isEmpty {
//                                        showSubscriptionOptions = true
//                                    }  else {
                                        isProcessingPurchase = true
                                        Task {
                                            await buyBoins(bundle: bundle)
                                        }
//                                    }
                                } label: {
                                    Rectangle()
                                        .fill(.yellow)
                                        .cornerRadius(45)
                                        .frame(height: 120)
                                        .overlay{
                                            HStack{
                                                Image(bundles[index].image)
                                                    .resizable()
                                                    .frame(width: 90, height: 90)
                                                    .customTextStroke()
                                                    .padding(.leading)
                                                Text(String(bundles[index].coins) + " Boins")
                                                    .bold()
                                                    .italic()
                                                    .font(.system(size: 27))
                                                    .customTextStroke(width:1.5)
                                                Spacer()
                                                Text(bundles[index].cost)
                                                    .foregroundColor(.black)
                                                    .font(.title2)
                                                    .lineLimit(1)
                                                    .minimumScaleFactor(0.01)
                                                    .italic()
                                                    .bold()
                                                    .padding(9)
                                                    .background(.green)
                                                    .cornerRadius(21)
                                                    .padding(3)
                                                    .background(.black)
                                                    .cornerRadius(24)
                                                    .padding(.trailing, 12)
                                            }
                                            if index == 1 {
                                                HStack{
                                                    Text("MOST POPULAR")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 12))
                                                        .padding(.horizontal, 9)
                                                        .padding(.vertical, 6)
                                                }
                                                .background{
                                                    Color.red
                                                }
                                                .roundedCorner(12, corners: [.bottomLeft, .bottomRight])
                                                .customTextStroke(width: 1.5)
                                                .offset(x: 39, y: -48)
                                            }
                                            if index == 4 {
                                                HStack{
                                                    Text("BEST DEAL!")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 12))
                                                        .padding(.horizontal, 9)
                                                        .padding(.vertical, 6)
                                                }
                                                .background{
                                                    Color.green
                                                }
                                                .roundedCorner(12, corners: [.bottomLeft, .bottomRight])
                                                .customTextStroke(width: 1.5)
                                                .offset(x: 39, y: -48)
                                            }

                                        }
                                        .mask{
                                            RoundedRectangle(cornerRadius: 45)
                                        }
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 45)
                                                .stroke(Color.black, lineWidth: 3)
                                                .frame(height: 120)
                                                .padding(1)
                                        }
                                        .accentColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 9)
                                }
                                .buttonStyle(.roundedAndShadow9)
                        }
//                        Button{
//                            impactHeavy.impactOccurred()
//                            showManageSubscriptions = true
//                        } label: {
//                            Text("Subscriptions 📆")
//                                .font(.system(size: 30))
//                                .customTextStroke(width: 2)
//                                .bold()
//                                .italic()
//                                .padding()
//                        }
                    }
                    .padding(.leading, 9)
            }
            if isProcessingPurchase {
                Color.gray.opacity(0.3) // Gray out the background
                    .edgesIgnoringSafeArea(.all)
                HangTight()
            
            }
        }
        .allowsHitTesting(!isProcessingPurchase)
        .sheet(isPresented: self.$showSubscriptionOptions) {
            SubscriptionOptions(bundle: $selectedBundle)
                .presentationDetents([.height(550)])
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

#Preview {
    CurrencyPageView()
}
