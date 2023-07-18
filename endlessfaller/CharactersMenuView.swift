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
        ScrollView{
            ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        let storeIndex = index - 1
                        let currentStoreKit = storeKit
                        if index < model.characters.count {
                            let character = model.characters[index]
                            Button {
                                if model.characters[index].isPurchased{
                                    model.selectedCharacter = index
                                } else if storeIndex >= 0 {
                                    Task {
                                        try await storeKit.purchase(currentStoreKit.storeProducts[storeIndex])
                                    }
                                }
                            } label: {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .cornerRadius(20)
                                    .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
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
                                                        .bold()
                                                } else {
                                                    Text("\(character.cost)")
                                                        .bold()
                                                }
                                                
                                            }
                                            .padding()
                                        }
                                    )
                                    .accentColor(.primary)
                                    .padding(1)
                                    .onChange(of: storeKit.purchasedCourses) { course in
                                        if storeIndex >= 0 {
                                            Task {
                                                model.characters[index].isPurchased = (try? await storeKit.isPurchased(currentStoreKit.storeProducts[storeIndex])) ?? false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
            }
        }
        .padding(.top, 30)
        .scrollIndicators(.hidden)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView()
    }
}
