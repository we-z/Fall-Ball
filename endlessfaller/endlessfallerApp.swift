//
//  endlessfallerApp.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
//import AVFoundation

@main
struct endlessfallerApp: App {
//    @StateObject var audioController = AudioManager(musicPlayer: AVAudioPlayer(), punchSoundEffect: AVAudioPlayer(), boingSoundEffect: AVAudioPlayer(), dingsSoundEffect: AVAudioPlayer())
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)
//                .environmentObject(audioController)
        }
    }
}
