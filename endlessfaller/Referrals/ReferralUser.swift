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
    static let referredBy = "referrer"
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
    
    func makeReferralLink(complete: @escaping (URL?) -> Void) {
        databaseRef.child(UserDataKey.referralCode).keepSynced(true)
        databaseRef.child(UserDataKey.referralCode).getData { error, snapshot in
            guard error == nil else {
                debugPrint("makeReferralLink - ERROR: \(error)")
                return
            }
            if let snapshot = snapshot {
                let URL = URL(string: "https://endlessfall.io/link/?\(UserDataKey.referredBy)=\(snapshot.value ?? "none")")
                complete(URL)
            }
        }
//        databaseRef.child(UserDataKey.referralCode).observeSingleEvent(of: .value) { snapshot in
//            let URL = URL(string: "https://endlessfall.io/link/?\(UserDataKey.referredBy)=\(snapshot.value ?? "none")")
//            complete(URL)
//        }
    }
    
//    func makeReferralLink() async -> URL? {
//        let snapshot = try? await databaseRef.child(UserDataKey.referralCode).getData()
//        guard let referralURL = URL(string: "https://endlessfall.io/link/?\(UserDataKey.referredBy)=\(snapshot?.value ?? "none")") else {
//            return nil
//        }
//        return referralURL
//    }
}
