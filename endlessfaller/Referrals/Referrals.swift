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
        if let user = Auth.auth().currentUser {
            if user.isAnonymous {
                debugPrint("verifyAnonymous - but we're already anonymous!")
                return
            }
        } else {
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
        // Ensure we don't keep signing in and creating countless users
        if let user = Auth.auth().currentUser {
            updateExistingUser(user)
            
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
        let codeGenerator = NanoID(alphabet: .uppercasedLatinLetters, .numbers, size: 5)
        
        userRef.updateChildValues([
            UserDataKey.signUpDate: ServerValue.timestamp(),
            UserDataKey.referralCode: codeGenerator.new()
        ])
        
        updateExistingUser(user)
    }
    
    static func updateExistingUser(_ user: User) {
        let userRef = user.databaseRef
        
        // Update the last time we've seen this user
        userRef.child(UserDataKey.lastLoginDate).setValue(ServerValue.timestamp())
        // Mirror the ubiquitous kv to Firebase
        userRef.updateChildValues(NSUbiquitousKeyValueStore.default.dictionaryRepresentation)
    }
    
    static func isReferralLink(_ url: URL) -> Bool {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return false
        }
        
        if components.host == "install" || url.lastPathComponent == "link" {
//            debugPrint("isReferralLink - \(url) - true")
            return true
        }
        return false
    }
    
    static func parseReferralLink(_ url: URL) -> String? {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.queryItems?.first(where: { queryItem in
            queryItem.name == UserDataKey.referredBy
        })?.value
    }
    
    /// This saves a first launch referral to a user's profile in Realtime
    /// Database. It waits for the user profile to become valid so it might
    /// happen at some point in the future if the user isn't logged in
    static func saveReferrer(url: URL) {
        guard let referralCode = Referrals.parseReferralLink(url) else {
            debugPrint("saveReferrer - FAILED to parse link: \(url)")
            return
        }
        
        Auth.auth().addStateDidChangeListener { auth, user in
            debugPrint("saveReferrer - authStateChange - \(auth) - \(user)")
            guard let user = user else {
                return
            }
//            debugPrint("saveReferrer - subscribing to check existing ref: \(user.databaseRef.description())")
            let dbRef = user.databaseRef
            dbRef.observeSingleEvent(of: .value) { snapshot in
                if (snapshot.hasChild(UserDataKey.referredBy) == false) {
                    debugPrint("saveReferrer - writing to user: \(dbRef.key)")
                    dbRef.child(UserDataKey.referredBy).setValue(referralCode)
                } else {
                    debugPrint("saveReferrer - ref wasn't nil NOT OVERWRITING: \(snapshot.childSnapshot(forPath: UserDataKey.referredBy).value!)")
                }
            }
        }
    }
}
