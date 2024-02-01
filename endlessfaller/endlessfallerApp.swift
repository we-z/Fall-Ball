//
//  endlessfallerApp.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import SwiftData

@main
struct endlessfallerApp: App {
//    @StateObject var audioController = AudioManager(musicPlayer: AVAudioPlayer(), punchSoundEffect: AVAudioPlayer(), boingSoundEffect: AVAudioPlayer(), dingsSoundEffect: AVAudioPlayer())
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: UserData.self)
    }
}
