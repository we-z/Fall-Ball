//
//  CloudKitPushNotifciationModel.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/3/24.
//

import Foundation
import CloudKit
import GameKit

class CloudKitPushNotifciationModel: ObservableObject {
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
    }
    
    func requestNotificationPermissions() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print(error)
            } else if success {
                print("Notification permissions success!")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure.")
            }
        }
    }
    
    func subscribeToNotifications() {
        unsubscribeToNotifications()
        let predicate = NSPredicate(format: "recieverAlias == %@", GKLocalPlayer.local.displayName)

        let subscription = CKQuerySubscription(recordType: "LeaderboardPass", predicate: predicate, subscriptionID: "challenge_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        
        // Arrays of possible titles and alert bodies
        let titles = ["You've Been Surpassed!", "Alert: Position Lost!", "Oops! You Slipped a Rank!", "You got passed on the leaderboard!"]
        let alertBodies = [
            "Looks like someone's overtaken you! 😱",
            "A player has passed you! Will you reclaim your spot? 🚀",
            "Your position has been stolen! Time for a comeback? 🏆",
            "You gon let em do you like dat 🤨"
        ]
        
        notification.title = titles.randomElement()
        notification.alertBody = alertBodies.randomElement()
        
        notification.soundName = "Boing.mp3"
        
        subscription.notificationInfo = notification
        
        CKContainer.default().publicCloudDatabase.save(subscription) { returnedSubscription, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully subscribed to notifications!")
            }
        }
    }
    
    func unsubscribeToNotifications() {
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "challenge_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
    
    func createPassRecord(recieverAlias: String) {
        guard let newPass = LeaderboardPassModel(recieverAlias: recieverAlias) else { return }
        CloudKitUtility.add(item: newPass) { result in }
    }
    
}

struct LeaderboardPassModel: Hashable, CloudKitableProtocol {
    let recieverAlias: String
    let record: CKRecord
    
    init?(record: CKRecord) {
        self.recieverAlias = ""
        self.record = record
    }
    
    init?(recieverAlias: String) {
        let record = CKRecord(recordType: "LeaderboardPass")
        record["recieverAlias"] = recieverAlias
        self.init(record: record)
    }
}
