//
//  UserData.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/31/24.
//

import Foundation
import SwiftData

@Model
class UserData {
    var bestScore: Int?
    var boinBalance: Int?
    var purchasedSkins: [String]?
    var selectedCharacter: String?
    var selectedBag: String?
    var selectedHat: String?
    var isMuted: Bool?
    
    init(bestScore: Int? = nil, boinBalance: Int? = nil, purchasedSkins: [String]? = nil, selectedCharacter: String? = nil, selectedBag: String? = nil, selectedHat: String? = nil, isMuted: Bool? = nil) {
        self.bestScore = bestScore
        self.boinBalance = boinBalance
        self.purchasedSkins = purchasedSkins
        self.selectedCharacter = selectedCharacter
        self.selectedBag = selectedBag
        self.selectedHat = selectedHat
        self.isMuted = isMuted
    }
}

//class UserDataManager: ObservableObject {
//    @Environment(\.modelContext) private var modelContext
//    @Query var userData: [UserData] = []
//    
//    func addBoins() {
//        
//    }
//    func removeBoins() {
//        
//    }
//}
