//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import GameKit
import CoreMotion
import Combine

struct ContentView: View {
    
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject private var notificationManager = NotificationManager()
    @ObservedObject var gameCenter = GameCenter()
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var audioController = AudioManager.sharedAudioManager
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject var userPersistedData = UserPersistedData()
    
    func boinFound() {
        appModel.showBoinFoundAnimation = true
        userPersistedData.incrementBalance(amount: 1)
        userPersistedData.resetBoinIntervalCounter()
    }
    
    let openToday = NSDate().formatted
    func checkIfAppOpenToday() {
        if (userPersistedData.lastLaunch == openToday) {
            //Already Launched today
            print("already opened today")
        } else {
            //Today's First Launch
            print("first open of the day")
            userPersistedData.updateLastLaunch(date: openToday)
            appModel.dailyBoinCollected()
            
        }
    }
    
    let heavyHaptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        ZStack{
            ScrollView {
                ZStack{
                    VTabView(selection: $appModel.currentIndex) {
                        ZStack{
                            RandomGradientView()
                            if appModel.showContinueToPlayScreen{
                                ContinuePlayingView()
                                VStack{
                                    HStack{
                                        if appModel.score > -1 {
                                            Text(String(appModel.score))
                                                .bold()
                                                .italic()
                                                .font(.system(size: 100))
                                                .padding(36)
                                                .padding(.top, 30)
                                                .foregroundColor(.black)
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .allowsHitTesting(false)
                            } else {
                                VStack{
                                    Text("Swipe up to\ncontinue")
                                        .padding()
                                    Image(systemName: "arrow.up")
                                }
                                .animatedOffset(speed: 1)
                                .font(.largeTitle)
                                .bold()
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .scaleEffect(1.5)
                                
                            }
                        }
                        .ignoresSafeArea()
                        .tag(-2)
                        ZStack{
                            Spacer()
                            if appModel.firstGamePlayed {
                                GameOverScreenView()
                            } else {
                                LandingPageView()
                            }
                            HomeButtonsView()
                        }
                        .background(RandomGradientView())
                        .tag(-1)
                        ForEach(appModel.colors.indices, id: \.self) { index in
                            ZStack{
                                RandomGradientView()
                                if index == 0 && appModel.score == 0 && !appModel.isWasted {
                                    if self.BallAnimator.ballYPosition > deviceHeight / 2 {
                                        SwipeUpNowView()
                                    } else {
                                        Instruction()
                                    }
                                }
                                VStack{
                                    Divider()
                                        .frame(height: 6)
                                        .overlay(index > appModel.currentIndex ? .black : .white)
                                        .offset(y: -6)
                                    Spacer()
                                }
                            }
                        }
                    }
                    .frame(
                        width: deviceWidth,
                        height: deviceHeight
                    )
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: $appModel.currentIndex.wrappedValue) { newIndex in
                        if newIndex == -1 {
                            appModel.gameOverOperations()
                        }
                        userPersistedData.incrementBoinIntervalCounter()
                        if userPersistedData.boinIntervalCounter > 1000 {
                            boinFound()
                        }
                        if newIndex > appModel.highestLevelInRound {
                            if newIndex == 0 {
                                appModel.dropBall()
                            } else if newIndex == 1 {
                                self.BallAnimator.pushBallUp(newBallSpeed: 3)
                            } else {
                                appModel.liftBall(difficultyInput: newIndex)
                            }
                            DispatchQueue.main.async {
                                appModel.score += 1
                                if audioController.musicPlayer.rate < 2 {
                                    audioController.musicPlayer.rate += 0.001
                                }
                            }
                            // 1052 or 1054
                            AudioServicesPlaySystemSound(1104)
                            appModel.highestLevelInRound = newIndex
                        }
                        appModel.FlashTriangles()
                        heavyHaptic.notificationOccurred(.success)
                        if appModel.score > userPersistedData.bestScore && newIndex > 3 {
                            appModel.showNewBestScore = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                appModel.showedNewBestScoreOnce = true
                            }
                        }
                    }
                    .allowsHitTesting(!appModel.freezeScrolling)
                    HUDView()
//                    LevelsToPassPlayerView()
                    PlayingBallView()
                }
            }
            .persistentSystemOverlays(.hidden)
            .edgesIgnoringSafeArea(.all)
            .scrollDisabled(appModel.freezeScrolling)
            .onAppear {
                notificationManager.registerLocal()
                notificationManager.scheduleLocal()
                appModel.playedCharacter = userPersistedData.selectedCharacter
                if !GKLocalPlayer.local.isAuthenticated {
                    gameCenter.authenticateUser()
                }
            }
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .background:
                    print("App is in background")
                    appModel.gameOverOperations()
                case .active:
                    print("App is Active")
                    checkIfAppOpenToday()
                case .inactive:
                    print("App is Inactive")
                @unknown default:
                    print("New App state not yet introduced")
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
