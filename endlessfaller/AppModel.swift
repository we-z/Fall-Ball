//
//  AppModel.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import Foundation
import SwiftUI

let selectedCharacterKey = "SelectedCharacter"
let purchasedCharactersKey = "PurchasedCharacters"



class AppModel: ObservableObject {
    
    @AppStorage(selectedCharacterKey) var selectedCharacter: Int = UserDefaults.standard.integer(forKey: selectedCharacterKey)
    @Published var purchasedCharacters: [String] = [] {
        didSet{
            savePurchasedCharacters()
        }
    }
        
    @Published var characters: [Character] = [
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.white))), cost: "Free", characterID: "io.endlessfall.white", isPurchased: true),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.black))), cost: "$2.99", characterID: "io.endlessfall.black", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.orange))), cost: "$2.99", characterID: "io.endlessfall.orange", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.blue))), cost: "$2.99", characterID: "io.endlessfall.blue", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.red))), cost: "$2.99", characterID: "io.endlessfall.red", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.green))), cost: "$2.99", characterID: "io.endlessfall.green", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.purple))), cost: "$2.99", characterID: "io.endlessfall.purple", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.pink.opacity(0.6)))), cost: "$2.99", characterID: "io.endlessfall.pink", isPurchased: false),
        Character(character: AnyView(BallView().background(Circle().foregroundColor(Color.yellow))), cost: "$2.99", characterID: "io.endlessfall.yellow", isPurchased: false),
        Character(character: AnyView(ChinaView()), cost: "$4.99", characterID: "io.endlessfall.china", isPurchased: false),
        Character(character: AnyView(AmericaView()), cost: "$4.99", characterID: "io.endlessfall.america", isPurchased: false),
        Character(character: AnyView(IndiaView()), cost: "$4.99", characterID: "io.endlessfall.india", isPurchased: false),
        Character(character: AnyView(AlbertView()), cost: "$9.99", characterID: "io.endlessfall.albert", isPurchased: false),
        Character(character: AnyView(MonkeyView()), cost: "$9.99", characterID: "io.endlessfall.monkey", isPurchased: false),
        Character(character: AnyView(IceSpiceView()), cost: "$9.99", characterID: "io.endlessfall.icespice", isPurchased: false),
        Character(character: AnyView(KaiView()), cost: "$9.99", characterID: "io.endlessfall.kai", isPurchased: false),
        Character(character: AnyView(RickView()), cost: "$9.99", characterID: "io.endlessfall.rick", isPurchased: false),
        Character(character: AnyView(MortyView()), cost: "$9.99", characterID: "io.endlessfall.morty", isPurchased: false)
        
    ] 
    
    func updatePurchasedCharacters(){
        print("updatePurchasedCharacters called")
        characters.forEach{ character in
            if character.isPurchased == true {
                if !purchasedCharacters.contains(character.characterID){
                    purchasedCharacters.append(character.characterID)
                }
            }
        }
        print("updatePurchasedCharacters: \(purchasedCharacters)")
    }
    
    func savePurchasedCharacters(){
        if let purchasedCharactes = try? JSONEncoder().encode(purchasedCharacters){
            UserDefaults.standard.set(purchasedCharactes, forKey: purchasedCharactersKey)
        }
        
    }
    func getPurchasedCharacters(){
        guard
            let charactersData = UserDefaults.standard.data(forKey: purchasedCharactersKey),
            let savedCharacters = try? JSONDecoder().decode([String].self, from: charactersData)
        else {return}
        
        self.purchasedCharacters = savedCharacters
        
        print("purchasedCharacters retrieved: \(purchasedCharacters)")
        
        purchasedCharacters.forEach{ purchasedCharacterID in
            for index in characters.indices {
                let character = characters[index]
                if character.characterID == purchasedCharacterID {
                    characters[index].isPurchased = true
                }
            }
        }
        print("purchasedCharacters assigned")
    }
    
    
    init() {
        getPurchasedCharacters()
    }
}

struct Character {
    let character: any View
    let cost: String
    let characterID: String
    var isPurchased: Bool
}

struct BallView: View {
    var body: some View {
        Circle()
            .strokeBorder(Color.primary,lineWidth: 1.5)
            .allowsHitTesting(false)
            .frame(width: 46, height: 46)
    }
}

struct BlinkViewModifier: ViewModifier {

    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0 : 1)
            .onAppear {
                withAnimation(.easeOut(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}



extension View {
    func blinking(duration: Double = 0.75) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
}
