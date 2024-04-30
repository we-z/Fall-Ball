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
    @State var showSecretShop = false
    @State var hapticFeedbackCounter = 0
    @State var showBallDetails = false
    @State var currentCharacter = Character(name: "", character: AnyView(WhiteBallView()), cost: "", characterID: "")
    @State var chosenBallIndex = 0
    @State var secretShopButtonIsPressed = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @StateObject var userPersistedData = UserPersistedData()
    @State private var searchText = ""
    
    private var filteredCharacters: [Character] {
        if searchText.isEmpty {
            return model.characters
        } else {
            return model.characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
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
                HStack{
                    Text("🌍 Ball Shop 🌍")
                        .customTextStroke(width: 1.8)
                        .italic()
                        .bold()
                        .font(.largeTitle)
                        .scaleEffect(1.1)
                }
                TextField("wqw", text: $searchText)
                    .overlay{
                        if searchText.isEmpty{
                            HStack{
                                Text("Search Balls...")
                                    .foregroundColor(.black)
                                    .allowsHitTesting(false)
                                Spacer()
                            }
                        }
                    }
                    .padding(9)
                    .padding(.horizontal, 9)
                    .foregroundColor(.black)
                    .background(.white.opacity(0.6))
                    .cornerRadius(12)
                    .padding(.horizontal, 12)
                ScrollView(showsIndicators: false){
                    ForEach(0..<(filteredCharacters.count + 2) / 3, id: \.self) { rowIndex in
                        HStack {
                            Spacer()
                            let startIndex = rowIndex * 3
                            // Calculate the end index, ensuring it does not exceed the count of filteredCharacters
                            let endIndex = min(startIndex + 3, filteredCharacters.count)
                            
                            ForEach(startIndex..<endIndex, id: \.self) { index in
                                let character = filteredCharacters[index]
                                let currentBallIndex = model.characters.firstIndex(where: {$0.characterID == character.characterID})!
                                if index < filteredCharacters.count {
                                    Button {
                                        currentCharacter = filteredCharacters[index]
                                        chosenBallIndex = currentBallIndex
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
                                                        if userPersistedData.purchasedSkins.contains(character.characterID) {
                                                            Text("Available")
                                                                .customTextStroke()
                                                                .bold()
                                                                .italic()
                                                        } else {
                                                            HStack(spacing: idiom == .pad ? 15 : 0){
                                                                if currentBallIndex > 8 {
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
                                                if filteredCharacters[index].characterID == userPersistedData.selectedCharacter {
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
                            .padding()
                    }
                    .buttonStyle(.roundedAndShadow6)
                }
            }
            
        }
        .sheet(isPresented: self.$showSecretShop){
            SecretShopView()
        }
        .sheet(isPresented: self.$showBallDetails){
            BallsDetailsView(ball: $currentCharacter, ballIndex: $chosenBallIndex)
                .presentationDetents([.height(550)])
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView()
    }
}

