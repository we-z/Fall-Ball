//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI
import StoreKit

struct CharactersMenuView: View {
    @StateObject var storeKit = StoreKitManager()
    @StateObject var model = AppModel()
    
    var body: some View {
        GeometryReader { geometry in
            HStack{
                Spacer()
                ScrollView(showsIndicators: false){
                    HStack{
                        Text("Ball Characters")
                            .bold()
                            .italic()
                            .font(.largeTitle)
                    }
                    ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                        HStack {
                            ForEach(0..<3, id: \.self) { columnIndex in
                                let index = rowIndex * 3 + columnIndex
                                let storeIndex = index - 1
                                if index < model.characters.count {
                                    let character = model.characters[index]
                                    Button {
                                        if model.characters[index].isPurchased{
                                            model.selectedCharacter = index
                                        } else if storeIndex >= 0 {
                                            //print("chosen product \(currentStoreKit.storeProducts[storeIndex])")
                                            Task {
                                                try await storeKit.purchase(characterID: character.characterID)
                                            }
                                        }
                                    } label: {
                                        Rectangle()
                                            .fill(Color.gray.opacity(0.3))
                                            .cornerRadius(20)
                                            .frame(width: geometry.size.width/3.3, height: geometry.size.width/3.3)
                                            .overlay{
                                                RoundedRectangle(cornerRadius: 20)
                                                    .stroke(index == model.selectedCharacter ? Color.primary : Color.clear, lineWidth: 2)
                                            }
                                            .overlay(
                                                ZStack{
                                                    VStack(spacing: 4) {
                                                        AnyView(character.character)
                                                        Spacer()
                                                        if model.characters[index].isPurchased && index != 0 {
                                                            Text("Available")
                                                        } else {
                                                            Text("\(character.cost)")
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
                                }
                            }
                        }
                    }
                    Button {
                        Task {
                            //This call displays a system prompt that asks users to authenticate with their App Store credentials.
                            //Call this function only in response to an explicit user action, such as tapping a button.
                            try? await AppStore.sync()
                        }
                    } label: {
                        Text("Restore Purchases")
                            .foregroundColor(.primary)
                            .underline()
                            .padding(.top)
                    }
                }
                .padding(.top, 30)
                //.scrollIndicators(.hidden)
                Spacer()
            }
        }
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView()
    }
}
