//
//  AudioManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import Foundation
import AVFoundation


class AudioManager: ObservableObject {
    @Published var musicPlayer: AVAudioPlayer!
    @Published var punchSoundEffect: AVAudioPlayer!
    @Published var boingSoundEffect: AVAudioPlayer!
    @Published var dingsSoundEffect: AVAudioPlayer!
    
    @Published var mute: Bool = false {
        didSet{
            saveAudiotSetting()
        }
    }
    
    static let sharedAudioManager = AudioManager()
    
    init() {
        getAudioSetting()
        setUpAudioFiles()
    }
    
    func getAudioSetting(){
        guard
            let muteData = UserDefaults.standard.data(forKey: muteKey),
            let savedMuteSetting = try? JSONDecoder().decode(Bool.self, from: muteData)
        else {return}
        
        self.mute = savedMuteSetting
    }
    
    func saveAudiotSetting() {
        if let muteSetting = try? JSONEncoder().encode(mute){
            UserDefaults.standard.set(muteSetting, forKey: muteKey)
        }
    }
    
    func setUpAudioFiles() {
        if let music = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3"){
            do {
                self.musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music))
                self.musicPlayer.numberOfLoops = -1
                self.musicPlayer.enableRate = true
                if mute == true {
                    self.musicPlayer.setVolume(0, fadeDuration: 0)
                } else {
                    self.musicPlayer.setVolume(1, fadeDuration: 0)
                }
                self.musicPlayer.play()
            } catch {
                print("Error playing audio: \(error)")
            }
        }
        if let punch = Bundle.main.path(forResource: "punchSFX", ofType: "mp3"){
            do {
                self.punchSoundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: punch))
            } catch {
                print("Error playing audio: \(error)")
            }
        }
        if let boing = Bundle.main.path(forResource: "Boing", ofType: "mp3"){
            do {
                self.boingSoundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: boing))
            } catch {
                print("Error playing audio: \(error)")
            }
        }
        if let dings = Bundle.main.path(forResource: "DingDingDing", ofType: "mp3"){
            do {
                self.dingsSoundEffect = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: dings))
            } catch {
                print("Error playing audio: \(error)")
            }
        }
    }
}
