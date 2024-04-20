//
//  UserData.swift
//  Fall Ball
//
//  Created by Sam on 4/13/24.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

enum UserDataKey {
    static let verificationID = "authVerificationID"
    static let lastLoginDate = "lastLoginDate"
    static let signUpDate = "signUpDate"
    static let referralCode = "referralCode"
    static let referredBy = "ref"
    static let displayName = "displayName"
}

extension User {
    static var verificationID: String? {
        return UserDefaults().string(forKey: UserDataKey.verificationID)
    }
    
    static func setVerificationID(_ verification: String) {
        UserDefaults().setValue(verification, forKey: UserDataKey.verificationID)
    }
    
    var databaseRef: DatabaseReference {
        return Database.database().reference(withPath: "/users/\(self.uid)")
    }
    
    func setDisplayName(_ name: String) {
        databaseRef.child(UserDataKey.displayName).setValue(name)
    }
    
    func makeReferralLink(complete: @escaping (URL?) -> Void) {
        databaseRef.child(UserDataKey.referralCode).keepSynced(true)
        databaseRef.child(UserDataKey.referralCode).getData { error, snapshot in
            guard error == nil else {
                debugPrint("makeReferralLink - ERROR: \(error!)")
                complete(nil)
                return
            }
            if let snapshot = snapshot {
                let URL = URL(string: "https://fallball.io/link/?\(UserDataKey.referredBy)=\(snapshot.value ?? "none")")
                complete(URL)
            }
        }
    }
    
    func makeReferralLinkAsync() async -> URL? {
        databaseRef.child(UserDataKey.referralCode).keepSynced(true)
        if let data = try? await databaseRef.child(UserDataKey.referralCode).getData(),
           let code = data.value as? String {
            return URL(string: "https://fallball.io/link/?\(UserDataKey.referredBy)=\(code)")
        } else {
            debugPrint("makeReferralLink - failed to generate referral link")
            return nil
        }
    }
}
