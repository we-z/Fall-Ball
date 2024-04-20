//
//  HUDView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/17/24.
//

import SwiftUI

struct HUDView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var userPersistedData = UserPersistedData()
    @State var pauseButtonPressed = false
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
                            .padding(36)
                            .padding(.top, UIDevice.isOldDevice ? 0 : 30)
                            .allowsHitTesting(false)
                        Spacer()
                        //                                    Text("\(speedFactor)")
                        //                                        .padding()
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
                                if self.BallAnimator.ballYPosition < deviceHeight * 0.2 && appModel.currentIndex != 0 && userPersistedData.strategyModeEnabled {
                                    ZStack{
                                        Image(systemName: "triangle.fill")
                                            .foregroundColor(.black)
                                            .scaleEffect(1.2)
                                            .offset(x: -0.1, y: -0.7)
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .font(.largeTitle)
                                    .scaleEffect(1.5)
                                    .padding(.top, 75)
                                    .padding(.horizontal, 30)
                                    .flashing()
                                }
                            }
                            Spacer()
                            HStack{
                                Spacer()
                                if self.BallAnimator.ballYPosition > deviceHeight * 0.8 && appModel.currentIndex != 0 {
                                    ZStack{
                                        Image(systemName: "triangle.fill")
                                            .foregroundColor(.black)
                                            .scaleEffect(1.2)
                                            .offset(x: -0.1, y: -0.7)
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundColor(.red)
                                    }
                                    .font(.largeTitle)
                                    .scaleEffect(1.5)
                                    .padding(40)
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
    }
}
