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
    
    func makeCredentials(_ verificationID: String, verificationCode: String) -> PhoneAuthCredential {
        return PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode
        )
    }
    
    func authorize(credential: AuthCredential, complete: @escaping (User, Bool) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            guard let result = result,
            let isNewUser = result.additionalUserInfo?.isNewUser else {
                return
            }
            
            if isNewUser == true, let moreInfo = result.additionalUserInfo {
                Analytics.logEvent("create_new_user", parameters: moreInfo.profile)
                provisionNewUser(result.user)
            } else {
                Analytics.logEvent("returning_user", parameters: ["uid": result.user.uid])
                updateExistingUser(result.user)
            }
            
            Analytics.setUserID(result.user.uid)
            
            complete(result.user, isNewUser)
        }
    }
    
    func provisionNewUser(_ user: User) {
        let userRef = user.databaseRef
        
        // Save the current timestamp as the sign up date
        userRef.child(UserDataKey.signUpDate).setValue(ServerValue.timestamp())
        
        // Generate a new referral code for this user
        let codeGenerator = NanoID(alphabet: .uppercasedLatinLetters, .numbers, size: 6)
        userRef.child(UserDataKey.referralCode).setValue(codeGenerator.new())
        
        // Save the referredBy so we can reward them later
        userRef.updateChildValues([UserDataKey.referredBy: codeGenerator.new()])
    }
    
    func updateExistingUser(_ user: User) {
        let userRef = user.databaseRef
        
        // Update the last time we've seen this user
        userRef.child(UserDataKey.lastLoginDate).setValue(ServerValue.timestamp())
    }
}
