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
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    @StateObject var storeKit = StoreKitManager()
    @ObservedObject private var model = AppModel.sharedAppModel
    @State var isProcessingPurchase = false
    @State var showSecretShop = false
    @State var hapticFeedbackCounter = 0
    @State var showBallDetails = false
    @State var yPosition: CGFloat = 0.0
    @State var currentCharacter = Character(character: AnyView(WhiteBallView()), cost: "", characterID: "", isPurchased: false)
    @State var currentBallIndex = 0
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State private var circleProgress: CGFloat = 0.0
    
    var body: some View {
        ZStack{
            model.gameOverBackgroundColor
                .ignoresSafeArea()
            
            GeometryReader { geometry in
                VStack{
                    Capsule()
                        .frame(maxWidth: 45, maxHeight: 9)
                        .padding(.top, 9)
                        .foregroundColor(.black)
                        .opacity(0.3)
                    HStack{
                        Text("🌍 Ball Shop 🌍")
                            .italic()
                            .bold()
                            .font(.largeTitle)
                            .scaleEffect(1.1)
                    }
                    HStack{
                        Spacer()
                        ScrollView(showsIndicators: false){
                            ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                                HStack {
                                    ForEach(0..<3, id: \.self) { columnIndex in
                                        let index = rowIndex * 3 + columnIndex
                                        if index < model.characters.count {
                                            let character = model.characters[index]
                                            Button {
                                                if index < 8 || model.characters[index].isPurchased {
                                                    model.selectedCharacter = model.characters[index].characterID
                                                } else {
                                                    currentCharacter = model.characters[index]
                                                    currentBallIndex = index
                                                    showBallDetails = true
                                                }
                                            } label: {
                                                Rectangle()
                                                    .fill(.clear)
                                                    .cornerRadius(20)
                                                    .frame(width: geometry.size.width/3.3, height: idiom == .pad ? 270 : 150)
                                                    .background(model.gameOverBackgroundColor.opacity(model.characters[index].characterID == model.selectedCharacter ? 1 : 0))
                                                    .cornerRadius(20)
                                                    .overlay(
                                                        ZStack{
                                                            VStack(spacing: 1) {
                                                                AnyView(character.character)
                                                                    .scaleEffect(idiom == .pad ? 2.7 : 1.8)
                                                                    .offset(y: idiom == .pad ? -12 : 0)
                                                                Spacer()
                                                                    .frame(maxHeight: 36)
                                                                if model.characters[index].isPurchased && index > 8 {
                                                                    Text("Available")
                                                                        .bold()
                                                                        .italic()
                                                                } else {
                                                                    HStack(spacing: idiom == .pad ? 21 : 0){
                                                                        if index > 8 {
                                                                            BoinsView()
                                                                                .scaleEffect(idiom == .pad ? 1 : 0.6)
                                                                                .padding(0)
                                                                        }
                                                                        Text("\(character.cost)")
                                                                            .bold()
                                                                            .italic()
                                                                            .font(.title3)
                                                                            .minimumScaleFactor(0.2)
                                                                            .scaleEffect(idiom == .pad ? 1.8 : 1)
                                                                            
                                                                            .padding(0)
                                                                            
                                                                    }
                                                                    .offset(y: idiom == .pad ? 30 : 0)
                                                                }
                                                                
                                                            }
                                                            .padding()
                                                        }
                                                            .offset(y:12)
                                                    )
                                                    .accentColor(.black)
                                                    .padding(1)
                                                    .onChange(of: model.characters) { newList in
                                                        model.updatePurchasedCharacters()
//                                                        if storeIndex >= 0 {
//                                                            Task {
//                                                                model.characters[index].isPurchased = (try? await storeKit.isPurchased(characterID: character.characterID)) ?? false
//                                                                model.updatePurchasedCharacters()
//                                                            }
//                                                        }
                                                    }
                                            }
                                            .buttonStyle(.roundedAndShadow)
//                                            .sheet(isPresented: self.$showBallDetails){
//                                                BallsDetailsView(ball: model.characters[index])
//                                            }
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
                                    .foregroundColor(.black)
                                    .underline()
                                    .padding(.top)
                            }
                            .overlay{
                                VStack{
                                    Text("Secret Shop 🤫")
                                        .font(.system(size: 12))
                                        .bold()
                                        .italic()
                                        .scaleEffect(yPosition > -(deviceHeight) ? 1 + ((deviceHeight - abs(yPosition)) / 390) : 1)
                                    if idiom == .pad {
                                        ZStack{
                                            Circle()
                                                .foregroundColor(.black)
                                                .frame(width: 69, height: 69)
                                            Circle()
                                                .trim(from: 0, to: (deviceHeight - abs(yPosition)) / (deviceHeight - 600))
                                                .stroke(Color.blue, lineWidth: 30)
                                                .rotationEffect(Angle(degrees: -90))
                                                .frame(width: 30, height: 30)
                                        }
                                        .offset(y: 15)
                                    } else {
                                        ZStack{
                                            Circle()
                                                .foregroundColor(.black)
                                                .frame(width: 69, height: 69)
                                            Circle()
                                                .trim(from: 0, to: (deviceHeight - abs(yPosition)) / (deviceHeight - 240))
                                                .stroke(Color.blue, lineWidth: 30)
                                                .rotationEffect(Angle(degrees: -90))
                                                .frame(width: 30, height: 30)
                                        }
                                        .offset(y: 15)
                                    }
                                }
                                .offset(y:120)
                            }
                            .background(GeometryReader { proxy -> Color in
                                DispatchQueue.main.async {
                                    yPosition = -proxy.frame(in: .global).maxY
                                    if idiom == .pad {
                                        if yPosition > -600 {
                                            self.showSecretShop = true
                                        }
                                    } else {
                                        if yPosition > -240 {
                                            self.showSecretShop = true
                                        }
                                    }
                                    if yPosition > -(deviceHeight - 90) {
                                        hapticFeedbackCounter += 1
                                        if hapticFeedbackCounter > 9 && !showSecretShop {
                                            impactMed.impactOccurred()
                                            hapticFeedbackCounter = 0
                                        }
                                    }
                                }
                                return Color.clear
                            })
                        }
                        Spacer()
                    }
                }
            }
//            Text("\(yPosition)")
//                .offset(y:100)
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
        .sheet(isPresented: self.$showBallDetails){
            BallsDetailsView(ball: $currentCharacter, ballIndex: $currentBallIndex)
                .presentationDetents([.height(390)])
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView()
    }
}

/*
 iphone 13 mini: -746
 iphone 15 pro max: -898
 ipad 12.9 inch: -1,346
 */
