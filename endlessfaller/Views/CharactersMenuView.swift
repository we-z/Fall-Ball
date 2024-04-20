//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI
import StoreKit
let impactMed = UIImpactFeedbackGenerator(style: .heavy)
struct CharactersMenuView: View {
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    @StateObject var storeKit = StoreKitManager()
    @ObservedObject private var model = AppModel.sharedAppModel
    @State var isProcessingPurchase = false
    @State var showSecretShop = false
    @State var hapticFeedbackCounter = 0
    @State var showBallDetails = false
    @State var currentCharacter = Character(name: "", character: AnyView(WhiteBallView()), cost: "", characterID: "")
    @State var currentBallIndex = 0
    @State var secretShopButtonIsPressed = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @StateObject var userPersistedData = AppModel.sharedAppModel.userPersistedData
    
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
                HStack{
                    Text("🌍 Ball Shop 🌍")
                        .customTextStroke(width: 1.8)
                        .italic()
                        .bold()
                        .font(.largeTitle)
                        .scaleEffect(1.1)
                }
                ScrollView(showsIndicators: false){
                    ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                        HStack {
                            Spacer()
                            ForEach(0..<3, id: \.self) { columnIndex in
                                let index = rowIndex * 3 + columnIndex
                                if index < model.characters.count {
                                    let character = model.characters[index]
                                    Button {
                                        currentCharacter = model.characters[index]
                                        currentBallIndex = index
                                        showBallDetails = true
                                    } label: {
                                        Rectangle()
                                            .fill(.clear)
                                            .cornerRadius(20)
                                            .frame(width: idiom == .pad ? deviceWidth/4.8 : deviceWidth/3.3, height: idiom == .pad ? 270 : 150)
                                            .background(RandomGradientView())
                                            .cornerRadius(20)
                                            .overlay{
                                                ZStack{
                                                    VStack(spacing: 1) {
                                                        AnyView(character.character)
                                                            .scaleEffect(idiom == .pad ? 2.7 : 1.8)
                                                            .offset(y: idiom == .pad ? -12 : 0)
                                                        Spacer()
                                                            .frame(maxHeight: 36)
                                                        if userPersistedData.purchasedSkins.contains(character.characterID) && index > 8 {
                                                            Text("Available")
                                                                .customTextStroke()
                                                                .bold()
                                                                .italic()
                                                        } else if index < 9 {
                                                            Text("Free")
                                                                .customTextStroke(width: 1.5)
                                                                .font(idiom == .pad ? .system(size: 36) :.system(size: 21))
                                                                .bold()
                                                                .italic()
                                                        } else {
                                                            HStack(spacing: idiom == .pad ? 15 : 0){
                                                                if index > 8 {
                                                                    BoinsView()
                                                                        .scaleEffect(idiom == .pad ? 1 : 0.6)
                                                                        .padding(0)
                                                                }
                                                                if character.cost.count < 4 {
                                                                    Text("\(character.cost)")
                                                                    
                                                                        .bold()
                                                                        .italic()
                                                                        .lineLimit(1)
                                                                        .customTextStroke(width: 1.2)
                                                                        .font(idiom == .pad ? .system(size: 39) : .system(size: 21))
                                                                        .padding(0)
                                                                    
                                                                } else {
                                                                    Text("\(character.cost)")
                                                                        .bold()
                                                                        .italic()
                                                                        .lineLimit(1)
                                                                        .minimumScaleFactor(0.01)
                                                                        .customTextStroke(width: 1.2)
                                                                        .font(idiom == .pad ? .system(size: 21) : .system(size: 18))
                                                                        .padding(0)
                                                                }
                                                                
                                                            }
                                                            .offset(y: idiom == .pad ? 30 : 0)
                                                        }
                                                        
                                                    }
                                                    .padding()
                                                }
                                                .offset(y:12)
                                                if model.characters[index].characterID == userPersistedData.selectedCharacter {
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(Color.black, lineWidth: 6)
                                                }
                                            }
                                            .accentColor(.black)
                                            .offset(y:6)
                                    }
                                    .buttonStyle(.characterMenu)
                                }
                            }
                            Spacer()
                        }
                    }
                    Button {
                        self.showSecretShop = true
                    } label: {
                        Text("Secret Shop 🤫")
                            .padding(6)
                            .padding(.horizontal, 6)
                            .customTextStroke()
                            .font(.system(size: 21))
                            .bold()
                            .italic()
                            .background(RandomGradientView())
                            .cornerRadius(12)
                            .padding(.vertical)
                    }
                    .buttonStyle(.roundedAndShadow6)
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

