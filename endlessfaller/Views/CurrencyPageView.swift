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
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                RandomGradientView()
                    .ignoresSafeArea()
                VStack{
                    Capsule()
                        .frame(maxWidth: 45, maxHeight: 9)
                        .padding(.top, 9)
                        .foregroundColor(.black)
                        .opacity(0.3)
                    HStack{
                        Text("💰🤩 Bundles 🤩💰")
                            .foregroundColor(.white)
                            .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                            .italic()
                            .bold()
                            .font(.largeTitle)
                            .scaleEffect(1.1)
                    }
                    HStack{
                        Spacer()
                        ScrollView(showsIndicators: false){
                            ForEach(0..<bundles.count/3, id: \.self) { rowIndex in
                                HStack {
                                    ForEach(0..<3, id: \.self) { columnIndex in
                                        let index = rowIndex * 3 + columnIndex
                                        if index < bundles.count {
                                            let bundle = bundles[index]
                                            Button {
                                                if index != 8 {
                                                    isProcessingPurchase = true
                                                    Task {
                                                        await buyBoins(bundle: bundle)
                                                    }
                                                } else {
                                                    showAlert = true
                                                }
                                            } label: {
                                                Rectangle()
                                                    .fill(.yellow)
                                                    .cornerRadius(20)
                                                    .frame(width: geometry.size.width/3.6, height: idiom == .pad ? 270 : 210)
                                                    .overlay{
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(Color.black, lineWidth: 3)
                                                            .frame(width: geometry.size.width/3.6, height: idiom == .pad ? 270 : 210)
                                                            .padding(1)
                                                        VStack{
                                                            BoinsView()
                                                                .scaleEffect(1.5)
                                                                .padding(.top)
                                                            if index != 8 {
                                                                Text(String(bundles[index].coins) + "\nBoins")
                                                                    .foregroundColor(.black)
                                                                    .multilineTextAlignment(.center)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.title2)
                                                                    .padding(.top, 6)
                                                            } else {
                                                                Text("∞")
                                                                    .foregroundColor(.black)
                                                                    .italic()
                                                                    .font(.largeTitle)
                                                                    .scaleEffect(1.8)
                                                                Text("Boins")
                                                                    .foregroundColor(.black)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.title2)
                                                                
                                                            }
                                                            Text(bundles[index].cost)
                                                                .foregroundColor(.black)
                                                                .padding(.vertical, 9)
                                                                .italic()
                                                                .bold()
                                                        }
                                                        if index == 1 {
                                                            HStack{
                                                                Spacer()
                                                                Text("Best Seller")
                                                                    .foregroundColor(.black)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.system(size: 15))
                                                                Spacer()
                                                                    
                                                            }
                                                            .background{
                                                                Color.red
                                                            }
                                                            .frame(width: 210)
                                                            .overlay{
                                                                Rectangle()
                                                                    .stroke(Color.black, lineWidth: 3)
                                                            }
                                                            .rotationEffect(.degrees(45))
                                                            .offset(x:idiom == .pad ? 60 : 21, y: idiom == .pad ? -90 : -69)
                                                            .mask{
                                                                Rectangle()
                                                                    .frame(width: geometry.size.width/3.6, height: idiom == .pad ? 270 : 210)
                                                            }
                                                            
                                                        }
                                                        if index == 8 {
                                                            HStack{
                                                                Spacer()
                                                                Text("Coming Soon")
                                                                    .foregroundColor(.black)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.system(size: 12))
                                                                Spacer()
                                                            }
                                                            .background{
                                                                Color.green
                                                            }
                                                            .frame(width: 210)
                                                            .overlay{
                                                                Rectangle()
                                                                    .stroke(Color.black, lineWidth: 3)
                                                            }
                                                            .rotationEffect(.degrees(45))
                                                            .offset(x:idiom == .pad ? 60 : 18, y: idiom == .pad ? -90 : -69)
                                                            .mask{
                                                                Rectangle()
                                                                    .frame(width: geometry.size.width/3.6, height: idiom == .pad ? 270 : 210)
                                                            }
                                                            
                                                        }
                                                    }
                                                    .accentColor(.black)
                                                    .padding(6)
                                            }
                                            .buttonStyle(.roundedAndShadow6)
                                            
                                        }
                                    }
                                }
                                .offset(x: 3)
                            }
                        }
                        Spacer()
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
