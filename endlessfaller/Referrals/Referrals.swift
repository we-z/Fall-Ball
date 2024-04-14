//
//  Referrals.swift
//  Fall Ball
//
//  Created by Sam on 4/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FirebaseAnalytics

struct Referrals {
    static func verifyAnonymous() {
        guard Auth.auth().currentUser?.isAnonymous == false else {
            debugPrint("verifyAnonymous - but we're already anonymous!")
            return
        }
        
        Auth.auth().signInAnonymously { result, error in
            guard error == nil else {
                debugPrint("signInAnonymously - ERROR: \(error!.localizedDescription)")
                return
            }
            if let credential = result?.credential {
                authorize(credential: credential) { user, done in
                    debugPrint("verifyAnonymous - authorize - \(user.debugDescription)")
                }
            }
        }
    }
    
    static func verifyGameCenter() async {
        if let credential = try? await GameCenterAuthProvider.getCredential() {
            if let result = try? await Auth.auth().currentUser?.link(with: credential) {
                debugPrint("Linked GameCenter to currentUser - \(result)")
            } else {
                authorize(credential: credential) { user, auth in
                    debugPrint("user: \(user.description) - auth: \(auth)")
                }
            }
        }
    }
    
    
    func makeCredentials(_ verificationID: String, verificationCode: String) -> PhoneAuthCredential {
        return PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
    }
    
    static func authorize(credential: AuthCredential, complete: @escaping (User, Bool) -> Void) {
        // Ensure we don't keep signing in and creating countless users®
        if let user = Auth.auth().currentUser {
            provisionNewUser(user)
            
            return complete(user, false)
        }
        
        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result,
            let isNewUser = result.additionalUserInfo?.isNewUser else {
                return
            }
            
            if isNewUser == true {
                handleNew(result.user)
            } else {
                handleReturning(result.user)
            }
            
            Analytics.setUserID(result.user.uid)
            
            complete(result.user, isNewUser)
        }
    }
    
    private static func handleReturning(_ user: User) {
        Analytics.logEvent(AnalyticsEventLogin, parameters: ["uid": user.uid])
        Referrals.updateExistingUser(user)
    }
    
    private static func handleNew(_ user: User) {
        Analytics.logEvent(AnalyticsEventSignUp, parameters: ["uid": user.uid])
        Referrals.provisionNewUser(user)
    }
    
    static func provisionNewUser(_ user: User) {
        let userRef = user.databaseRef
        
        // Save the current timestamp as the sign up date
        userRef.child(UserDataKey.signUpDate).setValue(ServerValue.timestamp())
        
        updateExistingUser(user)
    }
    
    static func updateExistingUser(_ user: User) {
        let userRef = user.databaseRef
        
        // Update the last time we've seen this user
        userRef.child(UserDataKey.lastLoginDate).setValue(ServerValue.timestamp())
        
        let codeGenerator = NanoID(alphabet: .uppercasedLatinLetters, .numbers, size: 6)
        userRef.updateChildValues([
            UserDataKey.referredBy: "SAMMY",
            UserDataKey.referralCode: codeGenerator.new()
        ])
    }
}
