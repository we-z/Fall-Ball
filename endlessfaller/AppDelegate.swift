//
//  AppDelegate.swift
//  Fall Ball
//
//  Created by Sam on 4/13/24.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseRemoteConfig
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func setUpRemoteConfig() {
        // Tweak some config
        let remoteConfigSettings = RemoteConfigSettings()
        remoteConfigSettings.minimumFetchInterval = 1000
        
        // Initialize RemoteConfig
        let remoteConfig = RemoteConfig.remoteConfig()
        remoteConfig.configSettings = remoteConfigSettings
        remoteConfig.fetchAndActivate { status, _ in
            debugPrint(status.rawValue)
            remoteConfig.fetchAndActivate { status, _ in
                debugPrint(status.rawValue)
            }
        }
    }
    
    func setUpUser() {
        Auth.auth().settings?.isAppVerificationDisabledForTesting = true
        
        Referrals.verifyAnonymous()
        Task {
            await Referrals.verifyGameCenter()
        }
    }
    
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      debugPrint("launch options: \(launchOptions?.debugDescription ?? "none")")
      
      // Use Firebase library to configure APIs
      FirebaseApp.configure()
      
      setUpRemoteConfig()
      setUpUser()
            
      return true
  }
    
    // Handle the custom URL attachments
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if Auth.auth().canHandle(url) {
            return true
        }
        
        return false
    }
    
    // Used for verifying via silent push notifications
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
        }
    }
    
    // Share the token for silent push verification
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Auth.auth().setAPNSToken(deviceToken, type: .unknown)
    }
}
