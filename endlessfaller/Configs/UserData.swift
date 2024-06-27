//
//  UserData.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/31/24.
//

import Foundation
import CloudStorage

class UserPersistedData: ObservableObject {
    @CloudStorage("bestScore") var bestScore: Int = 0
    @CloudStorage("boinBalance") var boinBalance: Int = 0
    @CloudStorage("purchasedSkins") var purchasedSkins: String = ""
    @CloudStorage("selectedCharacter") var selectedCharacter: String = "io.endlessfall.shocked"
    @CloudStorage("selectedBag") var selectedBag: String = "nobag"
    @CloudStorage("selectedHat") var selectedHat: String = "nohat"
    @CloudStorage("lastLaunch") var lastLaunch: String = ""
    @CloudStorage("lastBoinRenewal") var lastBoinRenewal: String = ""
    @CloudStorage("purchasedSubscriptionAmount") var purchasedSubscriptionAmount: Int = 0
    @CloudStorage("leaderboardWonToday") var leaderboardWonToday: Bool = false
    @CloudStorage("firstGameEverPlayed") var firstGameEverPlayed: Bool = false
    @CloudStorage("gameCenterLoggedIn") var gameCenterLoggedIn: Bool = false
    @CloudStorage("boinIntervalCounter") var boinIntervalCounter: Int = 0
    @CloudStorage("infiniteBoinsUnlocked") var infiniteBoinsUnlocked: Bool = false
    @CloudStorage("strategyModeEnabled") var strategyModeEnabled: Bool = false
    @CloudStorage("hasSharedFallBall") var hasSharedFallBall: Bool = false
    
    func addPurchasedSkin(skinName: String) {
        purchasedSkins += skinName
        purchasedSkins += ","
    }
    
    func skinIsPurchased(skinName: String) -> Bool {
        if purchasedSkins.contains(skinName) {
            return true
        } else {
            return false
        }
    }
    
    func incrementBoinIntervalCounter() {
        boinIntervalCounter += 1
    }
    
    func resetBoinIntervalCounter() {
        boinIntervalCounter = 0
    }
    
    func incrementBalance(amount: Int) {
        boinBalance += amount
    }
    
    func decrementBalance(amount: Int) {
        boinBalance -= amount
    }
    
    func updateBestScore(amount: Int) {
        bestScore = amount
    }
    
    func updateLastLaunch(date: String) {
        lastLaunch = date
    }
    
    func updateLastRenewal(date: String) {
        lastBoinRenewal = date
    }
    
    func selectNewBall(ball: String) {
        selectedCharacter = ball
    }
    
    func selectNewHat(hat: String) {
        selectedHat = hat
    }
    
    func selectNewBag(bag: String) {
        selectedBag = bag
    }
    
}
