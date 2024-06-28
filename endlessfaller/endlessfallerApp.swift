//
//  endlessfallerApp.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI

@main
struct endlessfallerApp: App {
    var body: some Scene {
#if os(visionOS)
        if #available(visionOS 2.0, *) {
            return WindowGroup {
                ContentView()
                    .environment(\.sizeCategory, .medium)
            }
            .volumeWorldAlignment(.gravityAligned)
            .windowStyle(.volumetric)
        }
#endif
        return WindowGroup {
            ContentView()
                .environment(\.sizeCategory, .medium)
#if os(iOS)
                .defersSystemGestures(on: .bottom)
#endif
        }
    }
}

