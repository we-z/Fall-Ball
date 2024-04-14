//
//  UserData.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/31/24.
//

import Foundation
import CloudStorage
import FirebaseAnalytics

class UserPersistedData: ObservableObject {
    @CloudStorage("bestScore") var bestScore: Int = 0
    @CloudStorage("boinBalance") var boinBalance: Int = 0
    @CloudStorage("purchasedSkins") var purchasedSkins: String = ""
    @CloudStorage("selectedCharacter") var selectedCharacter: String = "io.endlessfall.shocked"
    @CloudStorage("selectedBag") var selectedBag: String = "nobag"
    @CloudStorage("selectedHat") var selectedHat: String = "nohat"
    @CloudStorage("lastLaunch") var lastLaunch: String = ""
    @CloudStorage("leaderboardWonToday") var leaderboardWonToday: Bool = false
    @CloudStorage("boinIntervalCounter") var boinIntervalCounter: Int = 0
    @CloudStorage("infiniteBoinsUnlocked") var infiniteBoinsUnlocked: Bool = false
    @CloudStorage("strategyModeEnabled") var strategyModeEnabled: Bool = false
    
    func addPurchasedSkin(skinName: String) {
        purchasedSkins += skinName
        purchasedSkins += ","
        Analytics.logEvent("purchase", parameters: [AnalyticsParameterItemID: skinName])
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
        Analytics.logEvent(AnalyticsEventEarnVirtualCurrency, parameters: [
            AnalyticsParameterValue: amount,
            AnalyticsParameterVirtualCurrencyName: "boins",
            "new_balance": boinBalance
        ])
    }
    
    func decrementBalance(amount: Int) {
        boinBalance -= amount
        Analytics.logEvent(AnalyticsEventSpendVirtualCurrency, parameters: [
            AnalyticsParameterValue: amount,
            AnalyticsParameterVirtualCurrencyName: "boins",
            "new_balance": boinBalance
        ])
    }
    
    func updateBestScore(amount: Int) {
        bestScore = amount
        Analytics.setUserProperty(String(bestScore), forName: "best_score")
    }
    
    func updateLastLaunch(date: String) {
        lastLaunch = date
    }
    
    func selectNewBall(ball: String) {
        selectedCharacter = ball
        Analytics.setUserProperty(String(bestScore), forName: "selected_character")
    }
    
    func selectNewHat(hat: String) {
        selectedHat = hat
        Analytics.setUserProperty(String(bestScore), forName: "selected_hat")
    }
    
    func selectNewBag(bag: String) {
        selectedBag = bag
        Analytics.setUserProperty(String(bestScore), forName: "selected_bag")
    }
    
}
