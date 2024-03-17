//
//  NotificationManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/12/24.
//

import Foundation
import CloudKit
import GameKit

class NotificationManager: ObservableObject {
    
    // Define arrays of titles and bodies
    let titles = [
        "We miss you 🫶",
        "Hey there! 👋",
        "You're missed!",
        "Hello again! ✨",
        "Guess who's back? 🌟",
        "Your world awaits 🌍",
        "Adventure time! 🚀",
        "Ready for a challenge? 🎯",
        "Let's make today special! 🎉",
        "Unseen wonders await! 🌈"
    ]
    
    // Updated bodies to mention "boins" in each message
    let bodies = [
        "Come collect your daily boins bonus!",
        "Your adventure for boins awaits. Dive in!",
        "A surprise boin is waiting for you 🎁",
        "It's time for your daily boin!",
        "Unlock your daily boin reward now!",
        "Embark on a new quest today for more boins!",
        "Special rewards in boins for special players like you! 🏆",
        "Your favorite game misses you. Return for a boins surprise! ✨",
        "Epic boins adventures await your return!",
        "Your journey for boins continues today. Don't miss out! 🌟"
    ]
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
                self.subscribeToNotifications()
                self.scheduleLocal()
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func scheduleLocal() {
        print("scheduleLocal called")
        let center = UNUserNotificationCenter.current()

        // Randomly select a title and body
        let randomTitleIndex = Int.random(in: 0..<titles.count)
        let randomBodyIndex = Int.random(in: 0..<bodies.count)
        
        let content = UNMutableNotificationContent()
        content.title = titles[randomTitleIndex]
        content.body = bodies[randomBodyIndex]
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "BoingNotification.caf"))

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
        center.add(request)
    }
    
    func subscribeToNotifications() {
        unsubscribeToNotifications()
        let predicate = NSPredicate(format: "recieverAlias == %@", GKLocalPlayer.local.alias)

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
