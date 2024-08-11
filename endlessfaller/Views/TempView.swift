//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import LinkPresentation
import UIKit

struct ShareSheet: UIViewControllerRepresentable {
    var items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        // Provide custom metadata for link preview
        if let firstItem = items.first as? URL {
            controller.activityItemsConfiguration = [
                UIActivity.ActivityType.message,
                UIActivity.ActivityType.mail
            ] as? UIActivityItemsConfigurationReading

            let metadata = LPLinkMetadata()
            metadata.originalURL = firstItem
            metadata.url = firstItem
            metadata.title = "The Greatest Apple Pie In The World"
            metadata.imageProvider = NSItemProvider(contentsOf: Bundle.main.url(forResource: "apple-pie", withExtension: "jpg"))
            metadata.iconProvider = NSItemProvider(contentsOf: Bundle.main.url(forResource: "Icon", withExtension: "png"))

            if let activityItemsConfiguration = controller.activityItemsConfiguration as? UIActivityItemsConfiguration {
                activityItemsConfiguration.metadataProvider = { _ in
                    return metadata
                }
            }
        }
        
        return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update required
    }
}
struct TempView: View {
    @State private var isShareSheetPresented = false
        
        var body: some View {
            Button(action: {
                isShareSheetPresented = true
            }) {
                Text("Share Apple Pie")
            }
            .sheet(isPresented: $isShareSheetPresented) {
                ShareSheet(items: ["Check out the best apple pie!", URL(string: "https://www.example.com/apple-pie")!])
            }
        }
}

func activityViewControllerLinkMetadata(_: UIActivityViewController) -> LPLinkMetadata? {
    let metadata = LPLinkMetadata()
    metadata.originalURL = URL(string: "https://www.example.com/apple-pie")
    metadata.url = metadata.originalURL
    metadata.title = "The Greatest Apple Pie In The World"
    metadata.imageProvider = NSItemProvider(contentsOf: Bundle.main.url(forResource: "apple-pie", withExtension: "jpg"))
    metadata.iconProvider = NSItemProvider(contentsOf: Bundle.main.url(forResource: "Icon", withExtension: "png"))
    return metadata
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
