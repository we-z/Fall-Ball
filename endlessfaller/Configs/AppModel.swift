//
//  AppModel.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import Foundation
import SwiftUI

let selectedCharacterKey = "SelectedCharacterID"
let purchasedCharactersKey = "PurchasedCharacters"
let muteKey = "Mute"

class AppModel: ObservableObject {
    
    @AppStorage(selectedCharacterKey) var selectedCharacter: String = UserDefaults.standard.string(forKey: selectedCharacterKey) ?? "io.endlessfall.white"
    @Published var purchasedCharacters: [String] = [] {
        didSet{
            savePurchasedCharacters()
        }
    }
    
    @Published var mute: Bool = false {
        didSet{
            saveAudiotSetting()
        }
    }
    
    
    func saveAudiotSetting() {
        if let muteSetting = try? JSONEncoder().encode(mute){
            UserDefaults.standard.set(muteSetting, forKey: muteKey)
        }
    }
    
    func getAudioSetting(){
        guard
            let muteData = UserDefaults.standard.data(forKey: muteKey),
            let savedMuteSetting = try? JSONDecoder().decode(Bool.self, from: muteData)
        else {return}
        
        self.mute = savedMuteSetting
    }
        
    @Published var characters: [Character] = [
        Character(character: AnyView(WhiteBallView()), cost: "Free", characterID: "io.endlessfall.white", isPurchased: true),
        Character(character: AnyView(BlackBallView()), cost: "Free", characterID: "io.endlessfall.black", isPurchased: true),
        Character(character: AnyView(YinYangBallView()), cost: "Free", characterID: "io.endlessfall.orange", isPurchased: true),
        Character(character: AnyView(LaughBallView()), cost: "$2.99", characterID: "io.endlessfall.laugh", isPurchased: false),
        Character(character: AnyView(BombBallView()), cost: "$2.99", characterID: "io.endlessfall.bomb", isPurchased: false),
        Character(character: AnyView(ShockedBallView()), cost: "$2.99", characterID: "io.endlessfall.shocked", isPurchased: false),
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
        Character(character: AnyView(MexicoView()), cost: "$4.99", characterID: "io.endlessfall.mexico", isPurchased: false),
        Character(character: AnyView(PortugalView()), cost: "$4.99", characterID: "io.endlessfall.portugal", isPurchased: false),
        Character(character: AnyView(SpainView()), cost: "$4.99", characterID: "io.endlessfall.spain", isPurchased: false),
        Character(character: AnyView(SaudiArabiaView()), cost: "$4.99", characterID: "io.endlessfall.saudiarabia", isPurchased: false),
        Character(character: AnyView(UaeView()), cost: "$4.99", characterID: "io.endlessfall.uae", isPurchased: false),
        Character(character: AnyView(QatarView()), cost: "$4.99", characterID: "io.endlessfall.qatar", isPurchased: false),
        Character(character: AnyView(EthiopiaView()), cost: "$4.99", characterID: "io.endlessfall.ethiopia", isPurchased: false),
        Character(character: AnyView(NigeriaView()), cost: "$4.99", characterID: "io.endlessfall.nigeria", isPurchased: false),
        Character(character: AnyView(SouthAfricaView()), cost: "$4.99", characterID: "io.endlessfall.southafrica", isPurchased: false),
        Character(character: AnyView(PakistanView()), cost: "$4.99", characterID: "io.endlessfall.pakistan", isPurchased: false),
        Character(character: AnyView(BangladeshView()), cost: "$4.99", characterID: "io.endlessfall.bangladesh", isPurchased: false),
        Character(character: AnyView(IndonesiaView()), cost: "$4.99", characterID: "io.endlessfall.indonesia", isPurchased: false),
        Character(character: AnyView(AlbertView()), cost: "$9.99", characterID: "io.endlessfall.albert", isPurchased: false),
        Character(character: AnyView(MonkeyView()), cost: "$9.99", characterID: "io.endlessfall.monkey", isPurchased: false),
        Character(character: AnyView(IceSpiceView()), cost: "$9.99", characterID: "io.endlessfall.icespice", isPurchased: false),
        Character(character: AnyView(KaiView()), cost: "$9.99", characterID: "io.endlessfall.kai", isPurchased: false),
        Character(character: AnyView(RickView()), cost: "$9.99", characterID: "io.endlessfall.rick", isPurchased: false),
        Character(character: AnyView(MortyView()), cost: "$9.99", characterID: "io.endlessfall.morty", isPurchased: false)
        
    ] 
    
    func updatePurchasedCharacters(){
        characters.forEach{ character in
            if character.isPurchased == true {
                if !purchasedCharacters.contains(character.characterID){
                    purchasedCharacters.append(character.characterID)
                }
            }
        }
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
        
        //print("purchasedCharacters retrieved: \(purchasedCharacters)")
        
        purchasedCharacters.forEach{ purchasedCharacterID in
            for index in characters.indices {
                let character = characters[index]
                if character.characterID == purchasedCharacterID {
                    characters[index].isPurchased = true
                }
            }
        }
        //print("purchasedCharacters assigned")
    }
    
    
    init() {
        getPurchasedCharacters()
        getAudioSetting()
    }
}

struct Character: Hashable {
    let character: AnyView // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let cost: String
    let characterID: String
    var isPurchased: Bool

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(characterID)
    }

    static func ==(lhs: Character, rhs: Character) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.characterID == rhs.characterID
    }
}

struct BlinkViewModifier: ViewModifier {

    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.1 : 1)
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
    func strobing(duration: Double = 0.125 ) -> some View {
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
