//
//  ShareView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/5/23.
//

import SwiftUI
import LinkPresentation
import UniformTypeIdentifiers

class ActivityItemProvider: NSObject, UIActivityItemSource {
    let image: UIImage
    let url: URL

    init(image: UIImage, url: URL) {
        self.image = image
        self.url = url
    }

    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return image
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        return url
    }

    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        let appIcon = UIImage(named: "AppIcon")
        metadata.originalURL = url
        metadata.url = url
        metadata.title = "Play Fall Ball with me!"
        metadata.imageProvider = NSItemProvider(object: image)
        metadata.iconProvider = NSItemProvider(object: appIcon!)
        return metadata
    }
}

struct ShareView: UIViewControllerRepresentable {
    let image: UIImage
    let url: URL
    @ObservedObject var userPersistedData = UserPersistedData()

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityItems = [ActivityItemProvider(image: image, url: url)]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)

        activityViewController.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
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
        // No updates needed
    }
}
