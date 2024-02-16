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
import CircularProgress

let levels = 1000

struct ContentView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject private var notificationManager = NotificationManager()
    @ObservedObject var gameCenter = GameCenter()
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State var showDailyBoinCollectedAnimation = false
    @State private var triangleScale: CGFloat = 1.0
    @State var triangleColor = Color.black
    @Environment(\.scenePhase) var scenePhase
    @StateObject var userPersistedData = UserPersistedData()
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let rotationQueDispatch = DispatchQueue.init(label: "io.endlessfaller.rotationque", qos: .userInitiated)
    @State private var ballRoll = Double.zero
    
    init() {
        self.queue.underlyingQueue = rotationQueDispatch
    }
    
    func boinFound() {
        appModel.showBoinFoundAnimation = true
        userPersistedData.incrementBalance(amount: 1)
        userPersistedData.resetBoinIntervalCounter()
    }
    
    func dailyBoinCollected() {
        showDailyBoinCollectedAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            showDailyBoinCollectedAnimation = false
        }
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
            dailyBoinCollected()
            
        }
    }

    
    let heavyHaptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag})
        ZStack{
            ScrollView {
                ZStack{
                    VTabView(selection: $appModel.currentIndex) {
                        ZStack{
                            Color.red
                            if appModel.showContinueToPlayScreen{
                                VStack{
                                    Spacer()
                                    if appModel.showWastedScreen{
                                        WastedView()
                                    } else {
                                        ContinuePlayingView()
                                    }
                                    Spacer()
                                }
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
                            HUDView()
                        }
                        .background(RandomGradientView())
                        .tag(-1)
                        ForEach(appModel.colors.indices, id: \.self) { index in
                            ZStack{
                                RandomGradientView()
                                if index == 0 && appModel.score == 0 {
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
                            audioController.musicPlayer.rate = 1
                        }
                        userPersistedData.incrementBoinIntervalCounter()
                        if userPersistedData.boinIntervalCounter > 1000 {
                            boinFound()
                        }
                        if newIndex > appModel.highestLevelInRound {
                            if newIndex == 0 {
                                appModel.dropBall()
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
                        enableScaleAndFlashForDuration()
                        heavyHaptic.notificationOccurred(.success)
                        if newIndex > userPersistedData.bestScore && newIndex > 3 {
                            appModel.showNewBestScore = true
                        }
                    }
                    .allowsHitTesting(!appModel.freezeScrolling)
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
                    if appModel.score >= 0 && appModel.currentIndex >= 0{
                        ZStack{
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
                            VStack{
                                Spacer()
                                HStack{
                                    Image(systemName: "arrowtriangle.right.fill")
                                        .scaleEffect(triangleScale)
                                        .foregroundColor(triangleColor)
                                    Spacer()
                                    Image(systemName: "arrowtriangle.left.fill")
                                        .scaleEffect(triangleScale)
                                        .foregroundColor(triangleColor)
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
                        ZStack{
                            HStack{
                                Divider()
                                    .frame(width: 3)
                                    .overlay(.black)
                                    .offset(x: -21, y: -21)
                                Divider()
                                    .frame(width: 3)
                                    .overlay(.black)
                                    .offset(y: -39)
                                Divider()
                                    .frame(width: 3)
                                    .overlay(.black)
                                    .offset(x: 21, y: -21)

                            }
                            .frame(width: 66, height: abs(60 / appModel.ballSpeed))
                            .offset(x: 0, y:-(60 / appModel.ballSpeed))
                            
                                    
                            if let character = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) {
                                ZStack{
                                    AnyView(bag!.bag)
                                    AnyView(character.character)
                                        .scaleEffect(1.5)
                                    if userPersistedData.selectedHat != "nohat" {
                                        AnyView(hat!.hat)
                                    }
                                }
                                .rotationEffect(.degrees(self.ballRoll * 60))
                                .offset(y: -12)
                            }
                        }
                        .position(x: deviceWidth / 2, y: self.BallAnimator.ballYPosition)
                        .onChange(of: self.BallAnimator.ballYPosition) { newYposition in
                            if deviceHeight - 24 < self.BallAnimator.ballYPosition || self.BallAnimator.ballYPosition < -23 {
                                print("ballYposition at wasted:")
                                print(self.BallAnimator.ballYPosition)
                                appModel.wastedOperations()
                            }
                        }
                        .offset(x: ballRoll * (deviceWidth / 3))
                        .onAppear {
                            motionManager.deviceMotionUpdateInterval =  1.0 / 60.0
                            self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                                guard let data = data else {
                                    print("Error: \(error!)")
                                    return
                                }
                                let attitude: CMAttitude = data.attitude
                                if attitude.roll > -1 && attitude.roll < 1 {
                                    ballRoll = attitude.roll
                                }
                            }
                        }
                        .allowsHitTesting(false)
                    }
                    if appModel.showBoinFoundAnimation{
                        BoinCollectedView()
                            .onAppear{
                                audioController.boingSoundEffect.play()
                            }
                    }
                    if showDailyBoinCollectedAnimation {
                        DailyBoinCollectedView()
                    }
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
    
    func enableScaleAndFlashForDuration() {
        triangleScale = 1.5 // Increase the scale factor
        triangleColor = Color.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            triangleScale = 1
            triangleColor = Color.black
        }
    }

    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
