//
//  endlessfallerApp.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI

@main
struct endlessfallerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
                .environment(\.sizeCategory, .medium)
                .defersSystemGestures(on: .bottom)
        }
    }
}
