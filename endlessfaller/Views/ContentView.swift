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
import SwiftData

let bestScoreKey = "bestscorekey"
let boinIntervalCounterKey = "boinIntervalCounterKey"
let levels = 1000

struct ContentView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject private var notificationManager = NotificationManager()
    @ObservedObject var gameCenter = GameCenter()
    @ObservedObject private var BallAnimator = BallAnimationManager()
    @ObservedObject private var audioController = AudioManager.sharedAudioManager
    @State var score: Int = -1
    @State var ballSpeed: Double = 0.0
    @State var currentIndex: Int = -1
    @State var costToContinue: Int = 1
    @State var firstGamePlayed = false
    @State var freezeScrolling = false
    @State var continueButtonIsPressed = false
    @State var showNewBestScore = false
    @State var showCurrencyPage = false
    @State var showContinueToPlayScreen = false
    @State var showWastedScreen = false
    @State var shouldContinue = false
    @State var showBoinFoundAnimation = false
    @State var showDailyBoinCollectedAnimation = false
    @State private var triangleScale: CGFloat = 1.0
    @State var triangleColor = Color.black
    @AppStorage(boinIntervalCounterKey) var boinIntervalCounter: Int = UserDefaults.standard.integer(forKey: boinIntervalCounterKey)
    @State var highestLevelInRound = -1
    @State private var gameOverTimer: Timer? = nil
    @State var circleProgress = 0.0
    @State var circleProgressTimer: Timer?
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) private var modelContext
    @Query var userData: [UserData]
    
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let rotationQueDispatch = DispatchQueue.init(label: "io.endlessfaller.rotationque", qos: .userInitiated)
    @State private var ballRoll = Double.zero
    @State var colors: [Color] = (1...levels).map { _ in
        Color(hex: backgroundColors.randomElement()!)!
    }
    
    init() {
        self.queue.underlyingQueue = rotationQueDispatch
    }
    func dropBall() {
        self.ballSpeed = 2
        BallAnimator.startTimer(speed: self.ballSpeed)
    }
    func liftBall(difficultyInput: Int) {
        /*
         level 1 is anywhere between 0.5 and 1.5 seconds
         level 1000 is anywhere between 0.1 and 0.3 seconds
         use newValue instead of score variable
         1 ->       1, 3
         1000 ->    0.1, 0.3
         */
        let m1 = -0.0004004004004004004
        let c1 = 0.5004004004004003
        let fastest = m1 * Double(difficultyInput) + c1

        let m2 = -0.0012012012012012011
        let c2 = 1.5012012012012013
        let slowest = m2 * Double(difficultyInput) + c2
        
        ballSpeed = Double.random(in: fastest...slowest)
        BallAnimator.pushBallUp(newBallSpeed: ballSpeed)
    }
    
    func boinFound() {
        showBoinFoundAnimation = true
        if !userData.isEmpty {
            let newBalance = UserData(boinBalance: (userData.last?.boinBalance ?? 0) + 1)
            modelContext.insert(newBalance)
        }
        boinIntervalCounter = 0
    }
    
    func dailyBoinCollected() {
        showDailyBoinCollectedAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            showDailyBoinCollectedAnimation = false
        }
    }
    
    let openToday = NSDate().formatted
    func checkIfAppOpenToday() {
        if (UserDefaults.standard.string(forKey: "lastLaunch") == openToday) {
            //Already Launched today
            print("already opened today")
        } else {
            //Today's First Launch
            print("first open of the day")
            dailyBoinCollected()
            UserDefaults.standard.setValue(openToday, forKey:"lastLaunch")
        }
    }
    
    func startCircleProgressTimer() {
        self.circleProgress = 0.0
        circleProgressTimer?.invalidate() // Invalidate any existing timer

        circleProgressTimer = Timer.scheduledTimer(withTimeInterval: 0.057, repeats: true) { timer in
            if self.circleProgress < 1.0 {
                self.circleProgress += 0.01 // Adjust increment as needed
            } else {
                timer.invalidate()
            }
        }
    }
    
    func gameOverOperations() {
        self.currentIndex = -1
        gameOverTimer?.invalidate()
        gameOverTimer = nil
        shouldContinue = true
        costToContinue = 1
        if score > -1 {
            appModel.currentScore = score
        }
        score = -1
        audioController.musicPlayer.rate = 1
        self.showContinueToPlayScreen = false
        showNewBestScore = false
        if appModel.currentScore > appModel.bestScore {
            UserDefaults.standard.set(appModel.bestScore, forKey: bestScoreKey)
            DispatchQueue.main.async{
                appModel.bestScore = appModel.currentScore
            }
        }
        DispatchQueue.main.async {
            self.highestLevelInRound = -1
            gameCenter.updateScore(currentScore: appModel.currentScore, bestScore: appModel.bestScore, ballID: appModel.selectedCharacter)
        }
    }
    
    func continuePlaying() {
        //print("continuePlaying called")
        gameOverTimer?.invalidate()
        gameOverTimer = nil
        if !userData.isEmpty {
            let newBalance = UserData(boinBalance: (userData.last?.boinBalance ?? 0) - costToContinue)
            modelContext.insert(newBalance)
        }
        costToContinue *= 2
        shouldContinue = true
        showContinueToPlayScreen = false
        currentIndex = 0
    }
    
    func wastedOperations() {
        self.highestLevelInRound = -1
        DispatchQueue.main.async{
            self.highestLevelInRound = -1
            self.circleProgress = 0.0
            showContinueToPlayScreen = true
            self.BallAnimator.endingYPosition = 23
            self.BallAnimator.pushUp = false
            self.currentIndex = -2
            
        }
        firstGamePlayed = true
        shouldContinue = false
        self.circleProgress = 0.0
        audioController.punchSoundEffect.play()
        appModel.currentScore = score
        
        showBoinFoundAnimation = false
        freezeScrolling = true
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        showWastedScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(hex: backgroundColors.randomElement()!)!
            }
            freezeScrolling = false
            self.currentIndex = -2
            self.highestLevelInRound = -1
            self.showWastedScreen = false
        }
        appModel.playedCharacter = appModel.selectedCharacter
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                
            print("calling from wasted operations")
            gameOverOperations()
            self.gameOverTimer?.invalidate()
            self.gameOverTimer = nil
                
        }
    }
    
    let heavyHaptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == appModel.selectedHat})
        let bag = appModel.bags.first(where: { $0.bagID == appModel.selectedBag})
        ZStack{
            ScrollView {
                ZStack{
                    VTabView(selection: $currentIndex) {
                        ZStack{
                            Color.red
                            if showContinueToPlayScreen{
                                VStack{
                                    Spacer()
                                    if showWastedScreen{
                                        WastedView()
                                    } else {
                                        HStack{
                                            Spacer()
                                            ZStack{
                                                VStack{
                                                    VStack{
                                                        HStack{
                                                            Spacer()
                                                            HStack(spacing: 0){
                                                                BoinsView()
                                                                    .scaleEffect(0.6)
                                                                Text(String(userData.isEmpty ? 0 : userData.last?.boinBalance ?? 0))
                                                                    .foregroundColor(.black)
                                                                    .bold()
                                                                    .italic()
                                                                    .font(.title)
                                                            }
                                                            .padding(.horizontal, 9)
                                                            .padding(.top, 12)
                                                            .padding(.trailing, 21)
                                                            .background(.yellow)
                                                            .cornerRadius(15)
                                                            .overlay{
                                                                RoundedRectangle(cornerRadius: 15)
                                                                    .stroke(Color.black, lineWidth: 3)
                                                            }
                                                            .offset(x: 9, y: -9)
                                                        }
                                                        Text("Continue?")
                                                            .foregroundColor(.black)
                                                            .bold()
                                                            .italic()
                                                            .font(.largeTitle)
                                                            .padding(.bottom, 27)
                                                        HStack{
                                                            Spacer()
                                                            Text("\(costToContinue)")
                                                                .foregroundColor(.black)
                                                                .bold()
                                                                .italic()
                                                                .font(.largeTitle)
                                                                .scaleEffect(1.2)
                                                                .padding(.trailing, 3)
                                                            BoinsView()
                                                            Spacer()
                                                        }
                                                        .padding(9)
                                                        .background(.yellow)
                                                        .cornerRadius(15)
                                                        .shadow(color: .black, radius: 0.1, x: continueButtonIsPressed ? 0 : -6, y: continueButtonIsPressed ? 0 : 6)
                                                        .offset(x: continueButtonIsPressed ? -6 : -0, y: continueButtonIsPressed ? 6 : 0)
                                                        .padding(.horizontal, 30)
                                                        .padding(.bottom, 30)
                                                        .pressEvents {
                                                            // On press
                                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                                continueButtonIsPressed = true
                                                            }
                                                        } onRelease: {
                                                            withAnimation {
                                                                continueButtonIsPressed = false
                                                            }
                                                            if !userData.isEmpty {
                                                                if userData.last?.boinBalance ?? 0 >= costToContinue{
                                                                    continuePlaying()
                                                                } else {
                                                                    showCurrencyPage = true
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .background(RandomGradientView())
                                                    .cornerRadius(21)
                                                    .overlay{
                                                        RoundedRectangle(cornerRadius: 21)
                                                            .stroke(Color.black, lineWidth: 6)
                                                            .padding(1)
                                                        ZStack{
                                                            Image(systemName: "stopwatch")
                                                                .foregroundColor(.black)
                                                                .bold()
                                                                .font(.largeTitle)
                                                                .scaleEffect(2.1)
                                                            Circle()
                                                                .frame(width: 56)
                                                                .foregroundColor(.white)
                                                                .offset(y:3.6)
                                                            Circle()
                                                                .trim(from: 0, to: self.appModel.circleProgress)
                                                                .stroke(Color.blue, lineWidth: 24)
                                                                .rotationEffect(Angle(degrees: -90))
                                                                .frame(width: 24)
                                                                .offset(y:3.6)
                                                                .onAppear{
                                                                    self.appModel.startCircleProgressTimer()
                                                                }
                                                            
                                                        }
                                                        .offset(x:-136, y: -99)
                                                    }
                                                    .frame(width: 300)
                                                    .padding(30)
                                                    
                                                    ZStack{
                                                        VStack{
                                                            Text("Swipe up\nto cancel")
                                                                .italic()
                                                                .bold()
                                                                .multilineTextAlignment(.center)
                                                                .foregroundColor(.black)
                                                                .padding()
                                                            Image(systemName: "arrow.up")
                                                                .foregroundColor(.black)
                                                                .bold()
                                                        }
                                                        .padding(60)
                                                        .font(.largeTitle)
                                                        .scaleEffect(1.2)
                                                    }
                                                    .animatedOffset(speed: 1)
                                                }
                                                .offset(y: 90)
                                            }
                                            Spacer()
                                        }}
                                    Spacer()
                                }
                                VStack{
                                    HStack{
                                        if score > -1 {
                                            Text(String(score))
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
                            if !firstGamePlayed {
                                LandingPageView()
                            } else {
                                GameOverScreenView()
                            }
                            HUDView()
                        }
                        .background(RandomGradientView())
                        .tag(-1)
                        ForEach(colors.indices, id: \.self) { index in
                            ZStack{
                                RandomGradientView()
                                if index == 0 && score == 0 {
                                    if self.BallAnimator.ballYPosition > deviceHeight / 2 {
                                        SwipeUpNowView()
                                    } else {
                                        Instruction()
                                    }
                                }
                                VStack{
                                    Divider()
                                        .frame(height: 6)
                                        .overlay(index > currentIndex ? .black : .white)
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
                    .onChange(of: currentIndex) {
                        if currentIndex == -1 {
                            gameOverOperations()
                        }
                        boinIntervalCounter += 1
                        if boinIntervalCounter > 1000 {
                            boinFound()
                        }
                        if currentIndex > highestLevelInRound {
                            if currentIndex == 0 {
                                dropBall()
                            } else {
                                liftBall(difficultyInput: currentIndex)
                            }
                            DispatchQueue.main.async {
                                score += 1
                                if audioController.musicPlayer.rate < 2 {
                                    audioController.musicPlayer.rate += 0.001
                                }
                            }
                            // 1052 or 1054
                            AudioServicesPlaySystemSound(1104)
                            highestLevelInRound = currentIndex
                        }
                        enableScaleAndFlashForDuration()
                        heavyHaptic.notificationOccurred(.success)
                        if currentIndex > appModel.bestScore && currentIndex > 3 {
                            showNewBestScore = true
                        }
                    }
                    .allowsHitTesting(!freezeScrolling)
                    if !showNewBestScore {
                        
                        if score > 50 && score < 65 {
                            YourGood()
                        }
                        
                        if score > 100 && score < 115 {
                            YourInsane()
                        }
                        
                        if score > 300 && score < 315 {
                            GoBerzerk()
                        }
                        
                    } else {
                        NewBestScore()
                            .onAppear{
                                audioController.dingsSoundEffect.play()
                            }
                        CelebrationEffect()
                    }
                    if score >= 0 && currentIndex >= 0{
                        ZStack{
                            VStack{
                                HStack{
                                    Text(String(score))
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
                                    if self.BallAnimator.ballYPosition < deviceHeight * 0.15 && currentIndex != 0 {
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
                                    if self.BallAnimator.ballYPosition > deviceHeight * 0.85 && currentIndex != 0 {
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
                            .frame(width: 66, height: abs(60 / self.ballSpeed))
                            .offset(x: 0, y:-(60 / self.ballSpeed))
                            
                                    
                            if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                ZStack{
                                    AnyView(bag!.bag)
                                    AnyView(character.character)
                                        .scaleEffect(1.5)
                                    if appModel.selectedHat != "nohat" {
                                        AnyView(hat!.hat)
                                    }
                                }
                                .rotationEffect(.degrees(self.ballRoll * 60))
                                .offset(y: -12)
                            }
                        }
                        .position(x: deviceWidth / 2, y: self.BallAnimator.ballYPosition)
                        .onChange(of: self.BallAnimator.ballYPosition) {
                            if deviceHeight - 24 < self.BallAnimator.ballYPosition || self.BallAnimator.ballYPosition < 23 {
                                wastedOperations()
                            }
                        }
                        .offset(x: ballRoll * (deviceWidth / 3))
                        .onAppear {
                            if currentIndex > -1 {
                                self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                                    guard let data = data else {
                                        print("Error: \(error!)")
                                        return
                                    }
                                    let attitude: CMAttitude = data.attitude
                                    if currentIndex > -1 {
                                        if attitude.roll > -1 && attitude.roll < 1 {
                                            ballRoll = attitude.roll
                                        }
                                    }
                                }
                            }

                        }
                        .allowsHitTesting(false)
                    }
                    if showBoinFoundAnimation{
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
            .sheet(isPresented: self.$showCurrencyPage){
                CurrencyPageView()
            }
            .edgesIgnoringSafeArea(.all)
            .scrollDisabled(freezeScrolling)
            .onAppear {
                notificationManager.registerLocal()
                notificationManager.scheduleLocal()
                checkIfAppOpenToday()
                appModel.playedCharacter = appModel.selectedCharacter
                if !GKLocalPlayer.local.isAuthenticated {
                    gameCenter.authenticateUser()
                }
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
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
