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
    
//    @StateObject private var vm = CloudKitPushNotifciationModel()
    @ObservedObject var gameCenter = GameCenter.shared
        
    var body: some View {
        VStack(spacing: 40) {
            Button("login game center") {
                gameCenter.authenticateUser()
            }
            
//            Button("Request notification permissions") {
//                vm.requestNotificationPermissions()
//            }
//            
//            Button("Subscribe to notifications") {
//                vm.subscribeToNotifications()
//            }
//            
//            Button("Unsubscribe to notifications") {
//                vm.unsubscribeToNotifications()
//            }
//            
//            Button("add challenge to cloud") {
//                vm.createPassRecord(recieverAlias: "Juan")
//            }
        }
    }
}

#Preview {
    GKScoreChallengeTesterView()
}
