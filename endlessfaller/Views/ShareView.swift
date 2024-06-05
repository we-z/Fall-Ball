//
//  ShareView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/5/23.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    @ObservedObject var userPersistedData = UserPersistedData()

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            // Handle completion here
            if completed {
                print("Share completed successfully!")
                if !userPersistedData.hasSharedFallBall {
                    userPersistedData.incrementBalance(amount: 5)
                    userPersistedData.hasSharedFallBall = true
                }
            } else {
                print("User canceled the share.")
            }
        }
        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController,
               context: UIViewControllerRepresentableContext<ShareView>) {
        // empty
    }
}
