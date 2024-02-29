//
//  GKScoreChallengeTesterView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/20/24.
//

import SwiftUI
import GameKit
import CloudKit
import Combine

struct GKScoreChallengeTesterView: View {
    
    @StateObject private var vm = CloudKitPushNotifciationBootcampViewModel()
        
    var body: some View {
        VStack(spacing: 40) {
            
            Button("Authenticate Game Center") {
                vm.authenticateUser()
            }
            
            Button("Request notification permissions") {
                vm.requestNotificationPermissions()
            }
            
            Button("Subscribe to notifications") {
                vm.subscribeToNotifications()
            }
            
            Button("Unsubscribe to notifications") {
                vm.unsubscribeToNotifications()
            }
            
            Button("add challenge to cloud") {
                vm.createChallenge(senderAlias: "Juan", recieverAlias: GKLocalPlayer.local.alias, levelsPassed: 60)
            }
        }
    }
}

class CloudKitPushNotifciationBootcampViewModel: ObservableObject {
    
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
        var passer = "Someone"
        let predicate = NSPredicate(format: "recieverAlias == %@", GKLocalPlayer.local.alias)
        var cancellables = Set<AnyCancellable>()
        
        print("Player alias")
        print(GKLocalPlayer.local.alias)
        
//        let predicate = NSPredicate(value: true)

        let subscription = CKQuerySubscription(recordType: "Challenge", predicate: predicate, subscriptionID: "challenge_added_to_database", options: .firesOnRecordCreation)
        
        
        let notification = CKSubscription.NotificationInfo()
        
        
        
        notification.title = "subscription"
        notification.alertBody = "You gonna let em do you like dat? 🤨"
        notification.soundName = "Boing"
        
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
        CKContainer.default().publicCloudDatabase.delete(withSubscriptionID: "fruit_added_to_database") { returnedID, returnedError in
            if let error = returnedError {
                print(error)
            } else {
                print("Successfully unsubscribed!")
            }
        }
    }
    
    func createChallenge(senderAlias: String, recieverAlias: String, levelsPassed: Int) {
        guard let newScore = ChallengeModel(senderAlias: senderAlias, recieverAlias: recieverAlias, levelsPassed: levelsPassed) else { return }
        CloudKitUtility.add(item: newScore) { result in
            
        }
    }
    
}

struct ChallengeModel: Hashable, CloudKitableProtocol {
    let senderAlias: String
    let recieverAlias: String
    let levelsPassed: Int
    let record: CKRecord
    
    init?(record: CKRecord) {
        self.senderAlias = ""
        self.recieverAlias = ""
        self.levelsPassed = 0
        self.record = record
    }
    
    init?(senderAlias: String, recieverAlias: String, levelsPassed: Int) {
        let record = CKRecord(recordType: "Challenge")
        record["senderAlias"] = senderAlias
        record["recieverAlias"] = recieverAlias
        record["levelsPassed"] = levelsPassed
        self.init(record: record)
    }
}


#Preview {
    GKScoreChallengeTesterView()
}
