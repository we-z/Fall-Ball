//
//  CurrencyPageView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/21/23.
//

import SwiftUI

struct CurrencyPageView: View {
    @State var isProcessingPurchase = false
    @State var showAlert = false
    @StateObject var storeKit = StoreKitManager()
    @StateObject var model = AppModel()
    @State var bundles: [CurrencyBundle] = [
        CurrencyBundle(coins: 25, cost: "$4.99", bundleID: "25coins"),
        CurrencyBundle(coins: 55, cost: "$9.99", bundleID: "55coins"),
        CurrencyBundle(coins: 125, cost: "$19.99", bundleID: "125coins"),
        CurrencyBundle(coins: 350, cost: "$49.99", bundleID: "350coins"),
        CurrencyBundle(coins: 800, cost: "$99.99", bundleID: "800coins"),
        CurrencyBundle(coins: 1700, cost: "$199.99", bundleID: "1700coins"),
        CurrencyBundle(coins: 3900, cost: "$499.99", bundleID: "3900coins"),
        CurrencyBundle(coins: 9999, cost: "$999.99", bundleID: "9999coins"),
        CurrencyBundle(coins: 0, cost: "$9,999.99", bundleID: "infinitecoins")
    ]
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        GeometryReader { geometry in
            ZStack{
                VStack{
                    Capsule()
                        .frame(maxWidth: 45, maxHeight: 9)
                        .padding(.top, 9)
                        .foregroundColor(.black)
                        .opacity(0.3)
                    HStack{
                        Text("💰 Bundles 💰")
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
                                                        do {
                                                            if (try await storeKit.purchase(characterID: bundle.bundleID)) != nil{
                                                                
                                                                model.balance += bundle.coins
                                                            }
                                                        } catch {
                                                            print("Purchase failed: \(error)")
                                                        }
                                                        isProcessingPurchase = false
                                                    }
                                                } else {
                                                    showAlert = true
                                                }
                                            } label: {
                                                Rectangle()
                                                    .fill(.yellow)
                                                    .cornerRadius(20)
                                                    .frame(width: geometry.size.width/3.3, height: idiom == .pad ? 270 : 210)
                                                    .overlay{
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(Color.primary, lineWidth: 3)
                                                            .padding(1)
                                                        VStack{
                                                            BoinsView()
                                                                .scaleEffect(1.5)
                                                                .padding(.top)
                                                            if index != 8 {
                                                                Text(String(bundles[index].coins) + "\nBoins")
                                                                    .multilineTextAlignment(.center)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.title2)
                                                                    .padding(.top, 6)
                                                            } else {
                                                                Text("∞")
                                                                    .italic()
                                                                    .font(.largeTitle)
                                                                    .scaleEffect(1.8)
                                                                Text("Boins")
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.title2)
                                                                
                                                            }
                                                            Text(bundles[index].cost)
                                                                .padding(.vertical, 9)
                                                                .italic()
                                                                .bold()
                                                        }
                                                    }
                                                    .accentColor(.primary)
                                                    .padding(1)
                                            }
                                            .buttonStyle(.roundedAndShadow)
                                            
                                        }
                                    }
                                }
                            }
                            
                        }
                        Spacer()
                    }
                }
                if isProcessingPurchase {
                    Color.gray.opacity(0.3) // Gray out the background
                        .edgesIgnoringSafeArea(.all)
                    ProgressView()
                        .scaleEffect(2)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
                
                }
            }
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
