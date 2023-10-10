//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI
import StoreKit

struct CharactersMenuView: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @StateObject var storeKit = StoreKitManager()
    @StateObject var model = AppModel()
    @State var isProcessingPurchase = false
    @State var showSecretShop = false
    @State var yPosition: CGFloat = 0.0
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @Binding  var backgroundColor: Color
    var body: some View {
        ZStack{
            Color.primary.opacity(0.05)
                .ignoresSafeArea()
//            
//            backgroundColor
//                
//                .overlay{
//                    Color.black.opacity(0.1)
//                }
//                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack{
                    HStack{
                        Text("🌍 Ball Shop 🌍")
                            .italic()
                            .bold()
                            .font(.largeTitle)
                            .scaleEffect(1.1)
                            .padding(.top, 30)
                    }
                    HStack{
                        Spacer()
                        ScrollView(showsIndicators: false){
                            ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                                HStack {
                                    ForEach(0..<3, id: \.self) { columnIndex in
                                        let index = rowIndex * 3 + columnIndex
                                        let storeIndex = index - 1
                                        if index < model.characters.count {
                                            let character = model.characters[index]
                                            Button {
                                                if model.characters[index].isPurchased || index < 3 {
                                                    model.selectedCharacter = model.characters[index].characterID
                                                } else {
                                                    isProcessingPurchase = true
                                                    Task {
                                                        do {
                                                            if (try await storeKit.purchase(characterID: character.characterID)) != nil{
                                                                model.selectedCharacter = model.characters[index].characterID
                                                            }
                                                        } catch {
                                                            print("Purchase failed: \(error)")
                                                        }
                                                        isProcessingPurchase = false
                                                    }
                                                }
                                            } label: {
                                                Rectangle()
                                                    .fill(Color.white)
                                                    .cornerRadius(20)
                                                    .frame(width: geometry.size.width/3.3, height: geometry.size.width/3.3)
                                                    .shadow(radius: 3, y: 2)
                                                    .overlay{
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(model.characters[index].characterID == model.selectedCharacter ? Color.primary : Color.clear, lineWidth: 2)
                                                    }
                                                    .overlay(
                                                        ZStack{
                                                            VStack(spacing: 4) {
                                                                AnyView(character.character)
                                                                    .scaleEffect(idiom == .pad ? 1.8 : 1)
                                                                    .offset(y: idiom == .pad ? 40 : 0)
                                                                Spacer()
                                                                if model.characters[index].isPurchased && index > 8 {
                                                                    Text("Available")
                                                                } else {
                                                                    Text("\(character.cost)")
                                                                        .scaleEffect(idiom == .pad ? 1.8 : 1)
                                                                        .offset(y: idiom == .pad ? -20 : 0)
                                                                }
                                                                
                                                            }
                                                            .padding()
                                                        }
                                                    )
                                                    .accentColor(.primary)
                                                    .padding(1)
                                                    .onChange(of: storeKit.purchasedProducts) { course in
                                                        if storeIndex >= 0 {
                                                            Task {
                                                                model.characters[index].isPurchased = (try? await storeKit.isPurchased(characterID: character.characterID)) ?? false
                                                                model.updatePurchasedCharacters()
                                                            }
                                                        }
                                                    }
                                            }
                                            .buttonStyle(.roundedAndShadow)
                                        }
                                    }
                                }
                            }
                            Button {
                                Task {
                                    //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                                    //Call this function only in response to an explicit user action, such as tapping a button.
                                    SKPaymentQueue.default().restoreCompletedTransactions()
                                }
                            } label: {
                                Text("Restore Purchases")
                                    .foregroundColor(.primary)
                                    .underline()
                                    .padding(.top)
                            }
                            .overlay{
                                Text("Secret Shop 🤫")
                                    .font(.system(size: 18))
                                    .bold()
                                    .italic()
                                    .offset(y:75)
                                    .scaleEffect(yPosition > -(deviceHeight) ? 1 + ((deviceHeight - abs(yPosition)) / 390) : 1)
                            }
                            .background(GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    yPosition = -proxy.frame(in: .global).maxY
                                    if -proxy.frame(in: .global).maxY > -300 {
                                        self.showSecretShop = true
                                    }
                                }
                                return Color.clear
                            })
                        }
                        Spacer()
                    }
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
        .sheet(isPresented: self.$showSecretShop){
            SecretShopView()
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView(backgroundColor: .constant(Color.pink))
    }
}
