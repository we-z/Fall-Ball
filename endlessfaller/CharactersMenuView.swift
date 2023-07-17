//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI


struct CharactersMenuView: View {
    
    @StateObject var model = AppModel()
    var body: some View {
        ScrollView{
            ForEach(0..<model.characters.count/3, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        if index < model.characters.count {
                            let character = model.characters[index]
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                                .overlay{
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(index == model.selectedCharacter ? Color.primary : Color.clear, lineWidth: 2)
                                }
                                .onTapGesture {
                                    model.selectedCharacter = index
                                }
                                .overlay(
                                    ZStack{
                                        VStack(spacing: 4) {
                                            AnyView(character.character)
                                            Spacer()
                                            Text("\(character.cost)")
                                                .bold()
                                            
                                        }
                                        .padding()
                                    }
                                )
                                .padding(1)
                            
                        }
                    }
                }
            }
        }
        .padding(.top, 30)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersMenuView()
    }
}
