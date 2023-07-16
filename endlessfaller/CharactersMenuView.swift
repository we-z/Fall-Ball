//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI

struct Character {
    let character: any View
    let cost: String
    let characterID: String
}

struct CharactersMenuView: View {
    
    @State private var selectedCharacter: Int = 0
    
    let characters: [Character] = [
        Character(character: BallView().foregroundColor(.white), cost: "Free", characterID: "white"),
        Character(character: BallView().foregroundColor(.black), cost: "$2.99", characterID: "black"),
        Character(character: BallView().foregroundColor(.orange), cost: "$2.99", characterID: "orange"),
        Character(character: BallView().foregroundColor(.blue), cost: "$4.99", characterID: "blue"),
        Character(character: BallView().foregroundColor(.red), cost: "$4.99", characterID: "red"),
        Character(character: BallView().foregroundColor(.green), cost: "$4.99", characterID: "green"),
        Character(character: BallView().foregroundColor(.purple), cost: "$9.99", characterID: "purple"),
        Character(character: BallView().foregroundColor(.cyan), cost: "$9.99", characterID: "cyan"),
        Character(character: BallView().foregroundColor(.yellow), cost: "$9.99", characterID: "yellow")
        
    ]
    
    var body: some View {
        ScrollView{
            ForEach(0..<characters.count/3, id: \.self) { rowIndex in
                HStack {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        if index < characters.count {
                            let character = characters[index]
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                                .onTapGesture {
                                    selectedCharacter = index
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
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(index == selectedCharacter ? Color.primary : Color.clear, lineWidth: 2)
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
