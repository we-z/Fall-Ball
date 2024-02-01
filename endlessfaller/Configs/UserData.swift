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
    var bestScore: Int
    var boinBalance: Int
    var purchasedSkins: [String]
    var selectedCharacter: String
    var selectedBag: String
    var selectedHat: String
    var isMuted: Bool
    
    init(bestScore: Int = 0, boinBalance: Int = 0, purchasedSkins: [String] = [], selectedCharacter: String = "io.endlessfall.laugh", selectedBag: String = "nobag", selectedHat: String = "nohat", isMuted: Bool = false) {
        self.bestScore = bestScore
        self.boinBalance = boinBalance
        self.purchasedSkins = purchasedSkins
        self.selectedCharacter = selectedCharacter
        self.selectedBag = selectedBag
        self.selectedHat = selectedHat
        self.isMuted = isMuted
    }

}

