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
    @State var showAlert = false
    @StateObject var storeKit = StoreKitManager()
    @ObservedObject var appModel = AppModel.sharedAppModel
    @State var bundles: [CurrencyBundle] = [
        CurrencyBundle(coins: 25, cost: "$4.99", bundleID: "25boins"),
        CurrencyBundle(coins: 55, cost: "$9.99", bundleID: "55boins"),
        CurrencyBundle(coins: 125, cost: "$19.99", bundleID: "125boins"),
        CurrencyBundle(coins: 350, cost: "$49.99", bundleID: "350boins"),
        CurrencyBundle(coins: 800, cost: "$99.99", bundleID: "800boins"),
        CurrencyBundle(coins: 1700, cost: "$199.99", bundleID: "1700boins"),
        CurrencyBundle(coins: 3900, cost: "$499.99", bundleID: "3900boins"),
        CurrencyBundle(coins: 9999, cost: "$999.99", bundleID: "9999boins"),
        CurrencyBundle(coins: 0, cost: "$9,999.99", bundleID: "infinitecoins")
    ]
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @ObservedObject var userPersistedData = UserPersistedData()
    
    

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
    
    @MainActor
    func unlockInfiniteBoins() async {
        do {
            if (try await storeKit.purchase(bundleID: "infinite_boins")) != nil{
                DispatchQueue.main.async {
                    userPersistedData.infiniteBoinsUnlocked = true
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
                if userPersistedData.infiniteBoinsUnlocked {
                    VStack {
                        Spacer()
                        ZStack {
                            RotatingSunView()
                                .frame(maxWidth: deviceWidth)
                            VStack{
                                Text("∞")
                                    .font(.system(size: 180))
                                    .bold()
                                    .italic()
                                    .padding(1)
                                    .animatedOffset(speed: 2)
                                Text("Infinite Boins\nUnlocked\n🔓")
                                    .font(.largeTitle)
                                    .bold()
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .scaleEffect(1.5)
                            }
                            .frame(width: deviceWidth, height: deviceHeight / 2)
                            .customTextStroke(width: 3)
                            .offset(y:-60)
                        }
                        Spacer()
                    }
                } else {
                    Text("💰🤩 Bundles 🤩💰")
                        .customTextStroke()
                        .italic()
                        .bold()
                        .font(.largeTitle)
                        .scaleEffect(1.1)
                    ScrollView(showsIndicators: false){
                        ForEach(0..<bundles.count, id: \.self) { index in
                                let bundle = bundles[index]
                                Button {
                                    if index != 8 {
                                        isProcessingPurchase = true
                                        Task {
                                            await buyBoins(bundle: bundle)
                                        }
                                    } else {
//                                            Task {
//                                                await unlockInfiniteBoins()
//                                            }
                                        showAlert = true
                                    }
                                } label: {
                                    Rectangle()
                                        .fill(.yellow)
                                        .cornerRadius(20)
                                        .frame(height: 120)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.black, lineWidth: 3)
                                                .frame(height: 120)
                                                .padding(1)
                                            HStack{
                                                BoinsView()
                                                    .scaleEffect(1.5)
                                                    .padding()
                                                    .padding(.leading, deviceWidth / 30)
                                                if index != 8 {
                                                    Text(String(bundles[index].coins) + " Boins")
                                                        .customTextStroke(width: 1.5)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 27))
                                                } else {
                                                    Text("∞")
                                                        .customTextStroke()
                                                        .italic()
                                                        .font(.largeTitle)
                                                        .padding()
                                                        .scaleEffect(1.8)
                                                    Text("Boins")
                                                        .customTextStroke(width: 1.5)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 27))
                                                    
                                                }
                                                Spacer()
                                                Text(bundles[index].cost)
                                                    .font(.title2)
                                                    .lineLimit(1)
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
                                                    Spacer()
                                                    Text("MOST POPULAR")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 15))
                                                    Spacer()
                                                    
                                                }
                                                .background{
                                                    Color.orange
                                                }
                                                .overlay{
                                                    Rectangle()
                                                        .stroke(Color.black, lineWidth: 3)
                                                }
                                                .rotationEffect(.degrees(30))
                                                .offset(x:idiom == .pad ? deviceWidth / 3.9 : deviceWidth / 3.1, y: idiom == .pad ? -36 : -27)
                                                .mask{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .frame(width: idiom == .pad ? deviceWidth/1.55 : deviceWidth/1.1, height: 120)
                                                }
                                                
                                            }
                                            if index == 8 {
                                                HStack{
                                                    Spacer()
                                                    Text("COMING SOON")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                        .italic()
                                                        .font(.system(size: 15))
                                                    Spacer()
                                                    
                                                }
                                                .background{
                                                    Color.green
                                                }
                                                .overlay{
                                                    Rectangle()
                                                        .stroke(Color.black, lineWidth: 3)
                                                }
                                                .rotationEffect(.degrees(30))
                                                .offset(x:idiom == .pad ? deviceWidth / 3.9 : deviceWidth / 3.1, y: idiom == .pad ? -36 : -27)
                                                .mask{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .frame(width: idiom == .pad ? deviceWidth/1.55 : deviceWidth/1.1, height: 120)
                                                }
                                                
                                            }

                                        }
                                        .accentColor(.black)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 9)
                                }
                                .buttonStyle(.roundedAndShadow9)
                        }
                        
                    }
                    .padding(.leading, 9)
                }
            }
            if isProcessingPurchase {
                Color.gray.opacity(0.3) // Gray out the background
                    .edgesIgnoringSafeArea(.all)
                HangTight()
            
            }
        }
        .allowsHitTesting(!isProcessingPurchase)
        .alert("Coming Soon", isPresented: $showAlert) {
            Button("OK", role: .cancel) { }
        }
    }
}

struct CurrencyBundle: Hashable {
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
