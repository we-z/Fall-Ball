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
    var name: String
    var bestScore: Int
    var boinBalance: Int
    var purchasedSkins: [String]
    
    init(name: String, bestScore: Int, boinBalance: Int, purchasedSkins: [String]) {
        self.name = name
        self.bestScore = bestScore
        self.boinBalance = boinBalance
        self.purchasedSkins = purchasedSkins
    }
}

