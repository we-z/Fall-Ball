//
//  HUDView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/17/24.
//

import SwiftUI
import WidgetKit
import GameKit

struct HUDView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var userPersistedData = UserPersistedData()
    @State var pauseButtonPressed = false
    @ObservedObject var gameCenter = GameCenter.shared
    private var localPlayer = GKLocalPlayer.local
    
    var body: some View {
        ZStack{
            
            // rewards
            if appModel.currentIndex >= 0 && !appModel.isWasted {
                if !appModel.showNewBestScore {
                    
                    if appModel.score >= 0 && appModel.score < 4 {
                        KeepSwiping()
                    }
                    if userPersistedData.strategyModeEnabled {
                        if appModel.score > 3 && appModel.score < 9 {
                            Instruction3()
                        }
                        
                        if appModel.score > 8 && appModel.score < 15 {
                            Instruction2()
                        }
                    } else {
                        if appModel.score > 3 && appModel.score < 9 {
                            SwipeFaster()
                        }
                        
                        if appModel.score > 8 && appModel.score < 15 {
                            JustFaster()
                        }
                        if appModel.score > 14 && appModel.score < 21 {
                            SwipeAsFastAsYouCan()
                        }
                        if appModel.score > 20 && appModel.score < 30 {
                            SpeedInstruction()
                        }
                    }
                    
                    if appModel.score > 50 && appModel.score < 65 {
                        YourGood()
                    }
                    
                    if appModel.score > 100 && appModel.score < 115 {
                        YourInsane()
                    }
                    
                    if appModel.score > 300 && appModel.score < 315 {
                        GoBerzerk()
                    }
                    
                } else {
                    if !appModel.showedNewBestScoreOnce {
                        NewBestScore()
                            .onAppear{
                                audioController.dingsSoundEffect.play()
                            }
                        CelebrationEffect()
                    }
                }
            }
            
            if appModel.score >= 0 && appModel.currentIndex >= 0 {
                VStack{
                    HStack{
                        Text(String(appModel.score))
                            .customTextStroke(width: 3)
                            .bold()
                            .italic()
                            .font(.system(size: 100))
                            .padding([.horizontal, .top], 36)
                            .padding(.top, UIDevice.isOldDevice ? 0 : 30)
                            .allowsHitTesting(false)
                        Spacer()
                    }
                    HStack{
                        if userPersistedData.strategyModeEnabled{
                            HStack{
                                Text("+3")
                                    .font(.system(size: 60))
                            }
                            .bold()
                            .italic()
                            .customTextStroke(width: 2.7)
                            .scaleEffect(appModel.plus3Scale)
                            .rotationEffect(.degrees(appModel.plus3Rotation))
                            .padding(.horizontal, 30)
                        }
                        if appModel.jetPackOn{
                            HStack{
                                Text("+5")
                                    .font(.system(size: 60))
                            }
                            .bold()
                            .italic()
                            .customTextStroke(width: 2.7)
                            .padding(.horizontal, 30)
                            .flashing()
                        }
                        Spacer()
                    }
                    Spacer()
                    HStack{
                        if userPersistedData.strategyModeEnabled && !appModel.isWasted {
                            Button {
                                if !appModel.paused {
                                    appModel.pauseGame()
                                } else {
                                    appModel.continueGame()
                                }
                            } label: {
                                
                                ZStack {
                                    Rectangle()
                                        .foregroundColor(.blue)
                                        .frame(width: 69, height: 75)
                                        .overlay{
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.black, lineWidth: 3)
                                                .padding(1)
                                        }
                                        .cornerRadius(15)
                                    Image(systemName: appModel.paused ? "play.fill" : "pause.fill")
                                        .foregroundColor(.white)
                                        .font(.system(size: 60))
                                }
                                .padding(30)
                            }
                            .buttonStyle(.roundedAndShadow6)
                        }
                        Spacer()
                    }
                }
                
                if !appModel.isWasted {
                    VStack{
                        HStack{
                            Spacer()
                            VStack {
                                LevelsToPassPlayerView()
                                    .allowsHitTesting(false)
                            }
                        }
                        Spacer()
                    }
                    ZStack{
                        VStack{
                            Spacer()
                            HStack{
                                Image(systemName: "arrowtriangle.right.fill")
                                    .scaleEffect(appModel.triangleScale)
                                    .foregroundColor(appModel.triangleColor)
                                Spacer()
                                Image(systemName: "arrowtriangle.left.fill")
                                    .scaleEffect(appModel.triangleScale)
                                    .foregroundColor(appModel.triangleColor)
                            }
                            Spacer()
                        }
                        VStack{
                            HStack{
                                Spacer()
                                if self.BallAnimator.ballYPosition < deviceHeight * 0.3 && appModel.currentIndex != 0 && userPersistedData.strategyModeEnabled {
                                    ZStack{
                                        Image(systemName: "triangle.fill")
                                            .foregroundColor(.black)
                                            .scaleEffect(1.2)
                                            .offset(x: -0.1, y: -0.7)
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .font(.system(size: 60))
                                    .padding(.top, 75)
                                    .padding(.horizontal, 30)
                                    .flashing()
                                }
                            }
                            Spacer()
                            HStack{
                                Spacer()
                                if self.BallAnimator.ballYPosition > deviceHeight * 0.7 && appModel.currentIndex != 0 {
                                    ZStack{
                                        Image(systemName: "triangle.fill")
                                            .foregroundColor(.black)
                                            .scaleEffect(1.2)
                                            .offset(x: -0.1, y: -0.7)
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .font(.system(size: 60))
                                    .padding(30)
                                    .flashing()
                                }
                            }
                        }
                    }
                    .allowsHitTesting(false)
                    
                } else {
                    WastedView()
                }
            }
            if appModel.showBoostAnimation{
                BoostAnimation()
                    .onAppear{
                        audioController.dingsSoundEffect.play()
                    }
            }
            if appModel.showBoinFoundAnimation{
                BoinCollectedView()
                    .onAppear{
                        audioController.boingSoundEffect.play()
                    }
            }
            if appModel.show5boinsAnimation {
                LeaderboardRewardView()
            }
            if appModel.showDailyBoinCollectedAnimation {
                DailyBoinCollectedView()
            }
        }
//        .onChange(of: gameCenter.allTimePlayersList) { newList in
//            Task{
//                if let image = renderAllTimePodiumView() {
//                    saveImageToDisk(image: image, fileName: "allTimePodium.png")
//                }
//                if let image = renderTodaysPodiumView() {
//                    saveImageToDisk(image: image, fileName: "todaysPodium.png")
//                }
//            }
//        }
    }
    
    @Environment(\.displayScale) var displayScale
    
    @MainActor
    private func renderAllTimePodiumView() -> UIImage?{
        
        let renderer = ImageRenderer(content: PodiumView(playersList: gameCenter.allTimePlayersList))

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    @MainActor
    private func renderTodaysPodiumView() -> UIImage?{
        
        let renderer = ImageRenderer(content: PodiumView(playersList: gameCenter.allTimePlayersList))

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    private func saveImageToDisk(image: UIImage, fileName: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.FallBallGroup") else {
            print("Error: Could not find container URL for the app group.")
            return
        }
        
        let url = containerURL.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            do {
                try data.write(to: url)
                print("Image saved successfully.")
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Error saving image: \(error)")
            }
        } else {
            print("Error: Could not convert image to PNG data.")
        }
    }
    
    func PodiumView (playersList: [Player]) -> some View {
        let PlayersList = playersList
        return ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0))
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: 180)
            VStack{
                Text("🏆 Podium 🏆")
                    .font(.system(size: 36))
                    .bold()
                    .italic()
                    .customShadow(width: 1.5)
                    .padding(.top, 90)
                Spacer()
                HStack{
                    VStack{
                        Circle()
                            .frame(width: 90)
                            .foregroundColor(PlayersList.count > 2 ? .clear : .gray)
                            .padding([.horizontal, .top])
                            .overlay{
                                if PlayersList.count > 2 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[2].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 90))
                                    }
                                }
                            }
                        Text("🥉")
                            .font(.largeTitle)
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 2 {
                            Text(PlayersList[2].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[2].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .bold()
                                .italic()
                            //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                        }
                    }
                    .frame(maxWidth: deviceWidth / 3)
                    .cornerRadius(21)
                    .padding(.leading)
                    .offset(y: 90)
                    .padding(.bottom, 30)
                    VStack{
                        Circle()
                            .frame(width: 100)
                            .foregroundColor(PlayersList.count > 0 ? .clear : .gray)
                            .padding([.horizontal])
                            .overlay{
                                //                                                                    RickView()
                                //                                                                        .scaleEffect(2.7)
                                if PlayersList.count > 0 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[0].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 100))
                                    }
                                }
                            }
                        Text("🥇")
                            .font(.largeTitle)
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 0 {
                            Text(PlayersList[0].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[0].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .bold()
                                .italic()
                        }
                    }
                    .cornerRadius(21)
                    .frame(maxWidth: deviceWidth / 3)
                    VStack{
                        Circle()
                            .frame(width: 90)
                            .foregroundColor(PlayersList.count > 1  ? .clear : .gray)
                            .padding([.horizontal, .top])
                            .overlay{
                                //                                                                    IceSpiceView()
                                //                                                                        .scaleEffect(2)
                                if PlayersList.count > 1 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[1].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 90))
                                    }
                                }
                            }
                        Text("🥈")
                            .font(.largeTitle)
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 1 {
                            Text(PlayersList[1].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[1].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.largeTitle)
                                .bold()
                                .italic()
                        }
                    }
                    .frame(maxWidth: deviceWidth / 3)
                    .cornerRadius(21)
                    .padding(.trailing)
                    .offset(y: 90)
                    .padding(.bottom, 30)
                }
                .offset(y: -180)
            }
            .scaleEffect(0.7)
        }
        .frame(width: 330, height: 330)
    }
    
}
