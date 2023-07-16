//
//  AppModel.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import Foundation
import SwiftUI

let selectedCharacterKey = "SelectedCharacter"

class AppModel: ObservableObject {
    
    @AppStorage(selectedCharacterKey) var selectedCharacter: Int = UserDefaults.standard.integer(forKey: selectedCharacterKey)
        
    @Published var characters: [Character] = [
        Character(character: AnyView(BallView().foregroundColor(.white)), cost: "Free", characterID: "white"),
        Character(character: AnyView(BallView().foregroundColor(.black)), cost: "$2.99", characterID: "black"),
        Character(character: AnyView(BallView().foregroundColor(.orange)), cost: "$2.99", characterID: "orange"),
        Character(character: AnyView(BallView().foregroundColor(.blue)), cost: "$4.99", characterID: "blue"),
        Character(character: AnyView(BallView().foregroundColor(.red)), cost: "$4.99", characterID: "red"),
        Character(character: AnyView(BallView().foregroundColor(.green)), cost: "$4.99", characterID: "green"),
        Character(character: AnyView(BallView().foregroundColor(.purple)), cost: "$9.99", characterID: "purple"),
        Character(character: AnyView(BallView().foregroundColor(.cyan)), cost: "$9.99", characterID: "cyan"),
        Character(character: AnyView(BallView().foregroundColor(.yellow)), cost: "$9.99", characterID: "yellow")
        
    ]
}

struct Character {
    let character: any View
    let cost: String
    let characterID: String
}
