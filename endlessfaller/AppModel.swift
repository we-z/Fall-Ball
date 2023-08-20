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
        Character(character: AnyView(WhiteBallView()), cost: "Free", characterID: "io.endlessfall.white", isPurchased: true),
        Character(character: AnyView(BlackBallView()), cost: "Free", characterID: "io.endlessfall.black", isPurchased: true),
        Character(character: AnyView(YinYangBallView()), cost: "Free", characterID: "io.endlessfall.orange", isPurchased: true),
        Character(character: AnyView(ChinaView()), cost: "$4.99", characterID: "io.endlessfall.china", isPurchased: false),
        Character(character: AnyView(AmericaView()), cost: "$4.99", characterID: "io.endlessfall.america", isPurchased: false),
        Character(character: AnyView(IndiaView()), cost: "$4.99", characterID: "io.endlessfall.india", isPurchased: false),
        Character(character: AnyView(JapanView()), cost: "$4.99", characterID: "io.endlessfall.japan", isPurchased: false),
        Character(character: AnyView(UkView()), cost: "$4.99", characterID: "io.endlessfall.uk", isPurchased: false),
        Character(character: AnyView(GermanyView()), cost: "$4.99", characterID: "io.endlessfall.germany", isPurchased: false),
        Character(character: AnyView(FranceView()), cost: "$4.99", characterID: "io.endlessfall.france", isPurchased: false),
        Character(character: AnyView(CanadaView()), cost: "$4.99", characterID: "io.endlessfall.canada", isPurchased: false),
        Character(character: AnyView(BrazilView()), cost: "$4.99", characterID: "io.endlessfall.brazil", isPurchased: false),
        Character(character: AnyView(ParaguayView()), cost: "$4.99", characterID: "io.endlessfall.paraguay", isPurchased: false),
        Character(character: AnyView(ColombiaView()), cost: "$4.99", characterID: "io.endlessfall.colombia", isPurchased: false),
        Character(character: AnyView(SouthKoreaView()), cost: "$4.99", characterID: "io.endlessfall.southkorea", isPurchased: false),
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

struct BlinkViewModifier: ViewModifier {

    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.3 : 1)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}

struct FlashViewModifier: ViewModifier {

    let duration: Double
    @State private var flash: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(flash ? 0.3 : 1)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever()) {
                    flash = true
                }
            }
    }
}



extension View {
    func blinking(duration: Double = 0.25 ) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
    func flashing(duration: Double = 0.25) -> some View {
        modifier(FlashViewModifier(duration: duration))
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}

