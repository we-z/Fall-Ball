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
    static func verifyPhone(_ phoneNumber: String, complete: @escaping (String?) -> Void) {
        PhoneAuthProvider.provider()
            .verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in      guard let verificationID = verificationID else {
                    if let error = error {
                        debugPrint("Error verifying phone. Details: \(error.localizedDescription)")
                    }
                    complete(nil)
                    return
                }
                
                User.setVerificationID(verificationID)
                // Sign in using the verificationID and the code sent to the user
                complete(verificationID)
            }
    }
    
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
            authorize(credential: credential) { user, auth in
                debugPrint("user: \(user.description) - auth: \(auth)")
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
        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result,
            let isNewUser = result.additionalUserInfo?.isNewUser else {
                return
            }
            
            if isNewUser == true, let moreInfo = result.additionalUserInfo {
                Analytics.logEvent("create_new_user", parameters: moreInfo.profile)
                Referrals.provisionNewUser(result.user)
            } else {
                Analytics.logEvent("returning_user", parameters: ["uid": result.user.uid])
                Referrals.updateExistingUser(result.user)
            }
            
            Analytics.setUserID(result.user.uid)
            
            complete(result.user, isNewUser)
        }
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
