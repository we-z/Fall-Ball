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
    
    var body: some View {
        ZStack{
            
            // rewards
            if appModel.currentIndex >= 0 {
                if !appModel.showNewBestScore {
                    
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
                    NewBestScore()
                        .onAppear{
                            audioController.dingsSoundEffect.play()
                        }
                    CelebrationEffect()
                }
            }
            
            if appModel.score >= 0 && appModel.currentIndex >= 0 {
                VStack{
                    HStack{
                        Text(String(appModel.score))
                            .bold()
                            .italic()
                            .font(.system(size: 100))
                            .padding(36)
                            .padding(.top, 30)
                            .foregroundColor(.black)
                        Spacer()
                        //                                    Text("\(speedFactor)")
                        //                                        .padding()
                    }
                    Spacer()
                }
                if !appModel.isWasted {
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
                                if self.BallAnimator.ballYPosition < deviceHeight * 0.15 && appModel.currentIndex != 0 {
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
                                if self.BallAnimator.ballYPosition > deviceHeight * 0.85 && appModel.currentIndex != 0 {
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
            if appModel.showDailyBoinCollectedAnimation {
                DailyBoinCollectedView()
            }
        }
    }
}
