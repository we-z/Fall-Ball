//
//  ActivitySharingViewController.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import GroupActivities
import SwiftUI
import UIKit

struct ActivitySharingViewController: UIViewControllerRepresentable {

    let activity: GroupActivity

    func makeUIViewController(context: Context) -> GroupActivitySharingController {
        return try! GroupActivitySharingController(activity)
    }

    func updateUIViewController(_ uiViewController: GroupActivitySharingController, context: Context) { }
}
