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

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      debugPrint("didFinishLaunching: \(launchOptions?.debugDescription ?? "none")")
      // Use Firebase library to configure APIs
      FirebaseApp.configure()
      
      Auth.auth().settings?.isAppVerificationDisabledForTesting = true
      
      guard let user = Auth.auth().currentUser else {
          Referrals.verifyPhone("+1 6505551234") { verification in
              if let savedId = verification {
                  let credential = Referrals().makeCredentials(savedId, verificationCode: "123456")
                  Referrals().authorize(credential: credential) { user, isNewUser in
                      debugPrint("newUser? \(isNewUser)")
                  }
              }
          }
          return true
      }
      
      debugPrint("Already signed in as user: \(user.uid)")
      Referrals().updateExistingUser(user)
      
      user.makeReferralLink { referralURL in
          guard let URL = referralURL else {
              return
          }
          debugPrint("Referral Link: \(URL)")
      }
      
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
