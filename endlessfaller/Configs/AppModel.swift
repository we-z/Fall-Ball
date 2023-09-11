//
//  AppModel.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import UIKit

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

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

//  Written by SerialCoder.dev
extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX - width, y: rect.minY - width, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()

}
