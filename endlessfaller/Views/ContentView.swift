//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import AudioToolbox
import AVFoundation
import GameKit
import AudioToolbox
import CoreMotion
import Combine


let bestScoreKey = "bestscorekey"
let boinIntervalCounterKey = "boinIntervalCounterKey"
let levels = 1000
let difficulty = 8

struct ContentView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    let modelName = UIDevice.modelName
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var appModel = AppModel()
    @ObservedObject private var notificationManager = NotificationManager()
    @ObservedObject var gameCenter = GameCenter()
    @State var score: Int = -1
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var costToContinue: Int = 1
    @State var secondsToFall: Double = 4
    @State var fraction: Double = 0.5
    @State var gameIsOver = false
    @State var firstGamePlayed = false
    @State var freezeScrolling = false
    @State var continueButtonIsPressed = false
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var showNewBestScore = false
    @State var showPlaqueShare = false
    @State var showCurrencyPage = false
    @State var showContinueToPlayScreen = false
    @State var gameShouldBeOver = false
    @State var showWastedScreen = false
    @State var shouldContinue = false
    @State var showInstructionsAndBall = true
    @State var muteIsPressed = false
    @State var ballButtonIsPressed = false
    @State var currencyButtonIsPressed = false
    @State var plaqueIsPressed = false
    @State var showBoinFoundAnimation = false
    @State var showDailyBoinCollectedAnimation = false
    @State private var triangleScale: CGFloat = 1.0
    @State var triangleColor = Color.black
    @AppStorage(boinIntervalCounterKey) var boinIntervalCounter: Int = UserDefaults.standard.integer(forKey: boinIntervalCounterKey)
    @State var highestLevelInRound = -1
    @State var gameOverBackgroundColor: Color = .white
    @State var playedCharacter = ""
    @State private var gameOverTimer: Timer? = nil
    @State var musicPlayer: AVAudioPlayer!
    @State var punchSoundEffect: AVAudioPlayer!
    @State var boingSoundEffect: AVAudioPlayer!
    @State var dingsSoundEffect: AVAudioPlayer!
    @State var placeOnLeaderBoard = 0
    @State var isBallButtonMovingUp = false
    @State var isSwipeBannerMovingUp = false
    @State private var circleProgress: CGFloat = 0.0
//    @State var levelYPosition: CGFloat = 0
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    let rotationQueDispatch = DispatchQueue.init(label: "io.endlessfaller.rotationque", qos: .userInitiated)
    @State private var ballRoll = Double.zero
    @State private var ballPosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: -23)
    @State private var timerSubscription: AnyCancellable?
    @State var speedFactor: Double = 0.003  // Speed factor for the circle's movement
    @State var colors: [Color] = (1...levels).map { _ in
        Color(hex: backgroundColors.randomElement()!)!
    }
    
    init() {
        self.queue.underlyingQueue = rotationQueDispatch
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    func dropBall() {
        ballPosition.y = 0
        timerSubscription?.cancel()
        timerSubscription = Timer.publish(every: 0.003, on: .main, in: .common)
           .autoconnect()
           .sink { _ in
               ballPosition.y += 1
           }
    }
    
    func boinFound() {
        showBoinFoundAnimation = true
        appModel.balance += 1
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
    
    func gameOverOperations() {
        //if currentIndex == -2 {
            self.currentIndex = -1
            gameOverTimer?.invalidate()
            gameOverTimer = nil
            shouldContinue = true
            costToContinue = 1
            //print("gameOverOperations called")
            currentScore = score
            score = -1
            musicPlayer.rate = 1
            self.showContinueToPlayScreen = false
            showInstructionsAndBall = true
            gameIsOver = true
            showNewBestScore = false
            if currentScore > bestScore {
                UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                DispatchQueue.main.async{
                    bestScore = currentScore
                }
            }
            self.secondsToFall = 4
            self.fraction = 0.5
            DispatchQueue.main.async {
                gameCenter.updateScore(currentScore: currentScore, bestScore: bestScore, ballID: appModel.selectedCharacter)
            }
        //}
        
    }
    
    func continuePlaying() {
        //print("continuePlaying called")
        gameOverTimer?.invalidate()
        gameOverTimer = nil
        appModel.balance -= costToContinue
        costToContinue *= 2
        shouldContinue = true
        showContinueToPlayScreen = false
        showInstructionsAndBall = true
        self.secondsToFall = 4
        self.fraction = 0.5
        currentIndex = 0
    }
    
    func wastedOperations() {
        gameShouldBeOver = true
        gameOverBackgroundColor = colors[currentIndex]
        DispatchQueue.main.async{
            showContinueToPlayScreen = true
            self.currentIndex = -2
            highestLevelInRound = -1
        }
        firstGamePlayed = true
        shouldContinue = false
         circleProgress = 0.0
        showInstructionsAndBall = false
        self.punchSoundEffect.play()
        currentScore = score
        
        showBoinFoundAnimation = false
        gameIsOver = true
        freezeScrolling = true
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        showWastedScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(hex: backgroundColors.randomElement()!)!
            }
            freezeScrolling = false
            self.secondsToFall = 4
            self.fraction = 0.5
            self.currentIndex = -2
            self.showWastedScreen = false
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                
            print("calling from wasted operations")
            gameOverOperations()
            self.gameOverTimer?.invalidate()
            self.gameOverTimer = nil
                
        }
    }
    
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == appModel.selectedHat})
        ZStack{
            ScrollView {
                ZStack{
                    VTabView(selection: $currentIndex) {
                        ZStack{
                            gameOverBackgroundColor
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
                                                                Text(String(appModel.balance))
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
                                                            .bold()
                                                            .italic()
                                                            .font(.largeTitle)
                                                            .padding(.bottom, 27)
                                                        HStack{
                                                            Spacer()
                                                            Text("\(costToContinue)")
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
                                                            if appModel.balance >= costToContinue{
                                                                continuePlaying()
                                                            } else {
                                                                showCurrencyPage = true
                                                            }
                                                        }
                                                    }
                                                    .background(.orange)
                                                    .cornerRadius(21)
                                                    .overlay{
                                                        RoundedRectangle(cornerRadius: 21)
                                                            .stroke(Color.black, lineWidth: 6)
                                                            .padding(1)
                                                        ZStack{
                                                            Image(systemName: "stopwatch")
                                                            //.bold()
                                                                .font(.largeTitle)
                                                                .scaleEffect(2.1)
                                                            Circle()
                                                                .frame(width: 59)
                                                                .foregroundColor(.white)
                                                                .offset(y:3.6)
                                                            Circle()
                                                                .frame(width: 50)
                                                                .foregroundColor(.blue)
                                                                .offset(y:3.6)
                                                            Circle()
                                                                .trim(from: 0, to: circleProgress)
                                                                .stroke(Color.white, lineWidth: 29)
                                                                .rotationEffect(Angle(degrees: -90))
                                                                .frame(width: 29)
                                                                .offset(y:3.6)
                                                            
                                                        }
                                                        .offset(x:-136, y: -99)
                                                        .onAppear{
                                                            withAnimation(.linear(duration: 6)) {
                                                                circleProgress = 1.0
                                                            }
                                                        }
                                                    }
                                                    .frame(width: 300)
                                                    .padding(30)
                                                    
                                                    VStack{
                                                        Text("Swipe up\nto cancel")
                                                            .italic()
                                                            .bold()
                                                            .multilineTextAlignment(.center)
                                                            .foregroundColor(.black)
                                                            .padding()
                                                        Image(systemName: "arrow.up")
                                                            .foregroundColor(.black)
                                                    }
                                                    .padding(60)
                                                    .font(.largeTitle)
                                                    .animatedOffset(speed: 1)
                                                    .scaleEffect(1.2)
                                                }
                                                .offset(y: 90)
                                            }
                                            .sheet(isPresented: self.$showCurrencyPage){
                                                CurrencyPageView()
                                            }
                                            Spacer()
                                        }}
                                    Spacer()
                                }
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
                                    }
                                    Spacer()
                                }
                                .allowsHitTesting(false)
                            }
                        }
                        .ignoresSafeArea()
                        .tag(-2)
                        VStack{
                            Spacer()
                            
                            if !firstGamePlayed {
                                ZStack{
                                    VStack{
                                        HStack{
                                            Spacer()
                                            HStack{
                                                BoinsView()
                                                Text(String(appModel.balance))
                                                    .bold()
                                                    .italic()
                                                    .font(.largeTitle)
                                            }
                                            .padding(.horizontal)
                                            .padding(.vertical, 6)
                                            .background{
                                                Color.yellow
                                            }
                                            .cornerRadius(15)
                                            .shadow(color: .black, radius: 0.1, x: currencyButtonIsPressed ? 0 : -6, y: currencyButtonIsPressed ? 0 : 6)
                                            .offset(x: currencyButtonIsPressed ? -6 : 0, y: currencyButtonIsPressed ? 6 : 0)
                                            .padding()
                                            .pressEvents {
                                                // On press
                                                withAnimation(.easeInOut(duration: 0.1)) {
                                                    currencyButtonIsPressed = true
                                                }
                                            } onRelease: {
                                                withAnimation {
                                                    currencyButtonIsPressed = false
                                                    showCurrencyPage = true
                                                }
                                            }
                                        }
                                        .padding(.top, 30)
                                        Spacer()
                                        VStack{
                                            Text("Swipe up \nto play!")
                                                .italic()
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.black)
                                                .padding()
                                            Image(systemName: "arrow.up")
                                                .foregroundColor(.black)
                                        }
                                        .animatedOffset(speed: 1)
                                        .bold()
                                        .font(.largeTitle)
                                        .scaleEffect(1.5)
                                        Spacer()
                                    }
                                    if showDailyBoinCollectedAnimation {
                                        DailyBoinCollectedView()
                                    }
                                }
                            } else {
                                VStack{
                                    HStack{
                                        Spacer()
                                        HStack{
                                            BoinsView()
                                            Text(String(appModel.balance))
                                                .bold()
                                                .italic()
                                                .font(.largeTitle)
                                        }
                                        .padding(.horizontal)
                                        .padding(.vertical, 6)
                                        .background{
                                            Color.yellow
                                        }
                                        .cornerRadius(15)
                                        .shadow(color: .black, radius: 0.1, x: currencyButtonIsPressed ? 0 : -6, y: currencyButtonIsPressed ? 0 : 6)
                                        .offset(x: currencyButtonIsPressed ? -6 : 0, y: currencyButtonIsPressed ? 6 : 0)
                                        .padding()
                                        .pressEvents {
                                            // On press
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                currencyButtonIsPressed = true
                                            }
                                        } onRelease: {
                                            withAnimation {
                                                currencyButtonIsPressed = false
                                                showCurrencyPage = true
                                            }
                                        }
                                    }
                                    .padding(.top, 30)
                                    Spacer()
                                    Text("Game Over!")
                                        .italic()
                                        .bold()
                                        .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.08))
                                    //                                    .randomColor()
                                        .scaleEffect(1.8)
                                    //                                    .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                                        .padding(.bottom, deviceHeight * 0.04)
                                    ZStack{
                                        HStack{
                                            VStack(alignment: .trailing){
                                                Spacer()
                                                    .frame(maxHeight: 10)
                                                HStack{
                                                    ZStack{
                                                        Text("Ball:")
                                                            .font(.title)
                                                            .bold()
                                                            .italic()
                                                            .foregroundColor(appModel.selectedHat == "nohat" ? .black : .clear)
                                                            .padding(.leading, 15)
                                                            .offset(x: 30)
                                                    }
                                                    Spacer()
                                                        .frame(maxWidth: 110)
                                                    Text("Score:")
                                                        .foregroundColor(.black)
                                                        .bold()
                                                        .italic()
                                                }
                                                Text(String(currentScore))
                                                    .bold()
                                                    .italic()
                                                    .offset(y: 6)
                                                    .foregroundColor(.black)
                                                    .font(.largeTitle)
                                                Spacer()
                                                    .frame(maxHeight: 15)
                                                Text("Best:")
                                                    .foregroundColor(.black)
                                                    .bold()
                                                    .italic()
                                                Text(String(bestScore))
                                                    .bold()
                                                    .italic()
                                                    .offset(y: 6)
                                                    .foregroundColor(.black)
                                                    .font(.largeTitle)
                                                Spacer()
                                                    .frame(maxHeight: 10)
                                            }
                                            .padding(.trailing, 30)
                                            .padding()
                                            .font(.title)
                                        }
                                        if let character = appModel.characters.first(where: { $0.characterID == playedCharacter}) {
                                            ZStack{
                                                AnyView(character.character)
                                                    .scaleEffect(1.5)
                                                AnyView(hat!.hat)
                                            }
                                            .scaleEffect(1.5)
                                            .offset(x: -70, y: appModel.selectedHat == "nohat" ? 18 : 30)
                                        }
                                    }
                                    .background{
                                        ZStack{
                                            Rectangle()
                                                .foregroundColor(.yellow)
                                                .cornerRadius(30)
                                                .shadow(color: .black, radius: 0.1, x: plaqueIsPressed ? 0 : -9, y: plaqueIsPressed ? 0 : 9)
                                                .padding(.horizontal,9)
                                            VStack{
                                                Spacer()
                                                HStack{
                                                    Image(systemName: "square.and.arrow.up")
                                                        .bold()
                                                        .font(.title2)
                                                        .padding(15)
                                                        .padding(.horizontal, 12)
                                                    Spacer()
                                                }
                                            }
                                        }
                                        
                                    }
                                    .offset(x: plaqueIsPressed ? -9 : 0, y: plaqueIsPressed ? 9 : 0)
                                    .pressEvents {
                                        // On press
                                        withAnimation(.easeInOut(duration: 0.1)) {
                                            plaqueIsPressed = true
                                        }
                                    } onRelease: {
                                        withAnimation {
                                            plaqueIsPressed = false
                                            showPlaqueShare = true
                                        }
                                    }
                                    
                                    VStack{
                                        Text("Swipe up to \nplay again!")
                                            .italic()
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.black)
                                            .padding(.top, deviceHeight * 0.06)
                                            .padding()
                                        Image(systemName: "arrow.up")
                                            .foregroundColor(.black)
                                        //.shadow(color: .black, radius: 3)
                                    }
                                    .bold()
                                    .foregroundColor(.black)
                                    .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.1))
                                    .animatedOffset(speed: 1)
                                    Spacer()
                                }
                                .onAppear() {
                                    withAnimation(Animation.linear(duration: 1).repeatForever(autoreverses: true)) {
                                        isBallButtonMovingUp.toggle()
                                    }
                                }
                            }
                            Spacer()
                            //if firstGamePlayed {
                            ZStack{
                                HStack{
                                    Image(systemName: appModel.mute ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .foregroundColor(.teal)
                                        .font(.largeTitle)
                                        .scaleEffect(1.5)
                                        .shadow(color: .black, radius: 0.1, x: muteIsPressed ? 0 : -3, y: muteIsPressed ? 0 : 3)
                                        .padding(36)
                                        .offset(x: muteIsPressed ? -3 : 0, y: muteIsPressed ? 3 : 0)
                                        .pressEvents {
                                            // On press
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                muteIsPressed = true
                                            }
                                        } onRelease: {
                                            //AudioServicesPlaySystemSound(1305)
                                            withAnimation {
                                                muteIsPressed = false
                                                appModel.mute.toggle()
                                            }
                                        }
                                        .onChange(of: appModel.mute) { setting in
                                            if setting == true {
                                                self.musicPlayer.setVolume(0, fadeDuration: 0)
                                            } else {
                                                self.musicPlayer.setVolume(1, fadeDuration: 0)
                                            }
                                        }
                                    Spacer()
                                    ZStack{
                                        if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                            ZStack{
                                                AnyView(character.character)
                                                AnyView(hat!.hat)
                                                    .scaleEffect(0.69)
                                                    .frame(maxHeight: 30)
                                            }
                                            .frame(maxWidth:45)
                                            .scaleEffect(ballButtonIsPressed ? 0.9 : 1.2)
                                        }
                                    }
                                    .padding(36)
                                    .pressEvents {
                                        // On press
                                        withAnimation(.easeInOut(duration: 0.1)) {
                                            ballButtonIsPressed = true
                                        }
                                    } onRelease: {
                                        withAnimation {
                                            ballButtonIsPressed = false
                                            showCharactersMenu = true
                                        }
                                    }
                                }
                                ZStack{
                                    PodiumView()
                                        .foregroundColor(.black)
                                        .padding(36)
                                        .pressEvents {
                                            
                                        } onRelease: {
                                            withAnimation {
                                                showLeaderBoard = true
                                            }
                                        }
                                }
                            }
                            //}
                        }
                        .background(gameOverBackgroundColor)
                        .tag(-1)
                        ForEach(colors.indices, id: \.self) { index in
                            ZStack{
                                    colors[index]
                                VStack{
                                    Divider()
                                        .frame(height: 6)
                                        .overlay(index > score ? .black : .white)
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
                    .onChange(of: currentIndex) { newValue in
                        if newValue == -1 {
                            if !shouldContinue{
                                print("calling from screen disappearing")
                                gameOverOperations()
                            }
                        }
                        
                        gameShouldBeOver = false
                        boinIntervalCounter += 1
                        if boinIntervalCounter > 1000 {
                            boinFound()
                        }
                        if newValue > highestLevelInRound {
                            if newValue == 0 {
                                dropBall()
                            } else {
                                withAnimation {
                                    ballPosition.y -= deviceHeight / 2
                                }
                                
                                //timerSubscription?.cancel()
                                
                                // Restart timer with new interval
                                timerSubscription = Timer.publish(every: Double.random(in: 0.001...0.003), on: .main, in: .common)
                                     .autoconnect()
                                     .sink { _ in
                                         ballPosition.y += 1
                                     }
                            }
                            
                            DispatchQueue.main.async {
                                score += 1
                                if self.musicPlayer.rate < 2 {
                                    self.musicPlayer.rate += 0.003
                                }
                            }
                            // 1052 or 1054
                            AudioServicesPlaySystemSound(1057)
                            highestLevelInRound = newValue
                        }
                        enableScaleAndFlashForDuration()
                        impactMed.impactOccurred()
                        if currentIndex > bestScore && currentIndex > 3 {
                            showNewBestScore = true
                        }
                    }
                    .allowsHitTesting(!freezeScrolling)
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
//                                    Text("\(levelYPosition)")
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
                        }
                        .allowsHitTesting(false)
                        ZStack{
                            if !gameShouldBeOver{
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
                                .frame(width: 66, height: abs(ballPosition.y * 0.1))
                                .offset(x: 0, y:-(ballPosition.y * 0.1))
                            }
                            if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                ZStack{
                                    AnyView(character.character)
                                        .scaleEffect(1.5)
                                    AnyView(hat!.hat)
                                }
                                .rotationEffect(.degrees(self.ballRoll * 60))

                                .offset(y: -12)
                            }
                        }
                        .position(ballPosition)
                        .onChange(of: ballPosition.y) { newYPosition in
                            if newYPosition < 0 || deviceHeight - 24 < newYPosition {
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
                                    if showInstructionsAndBall && currentIndex > -1 {
                                        if attitude.roll > -1 && attitude.roll < 1 {
                                            ballRoll = attitude.roll
                                        }
                                    }
                                }
                            }

                        }
                        .allowsHitTesting(false)
                    }
                    
                    if showInstructionsAndBall {
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
                                    self.dingsSoundEffect.play()
                                }
                            CelebrationEffect()
                        }
                        if score > 45 {
                            ReactionsView()
                                .offset(y: 70)
                        }
                        if score > 100 {
                            VStack{
                                Spacer()
                                HStack{
                                    SwiftUIXmasTree2()
                                        .scaleEffect(0.5)
                                        .offset(x:-deviceWidth/10)
                                    Spacer()
                                }
                            }
                        }
                        
                        if score > 9 {
                            VStack{
                                Spacer()
                                HStack{
                                    Spacer()
                                    SVGCharacterView()
                                        .scaleEffect(0.5)
                                        .offset(x:deviceWidth/10)
                                }
                            }
                            .allowsHitTesting(false)
                        }
                    }
                    if showBoinFoundAnimation{
                        BoinCollectedView()
                            .onAppear{
                                self.boingSoundEffect.play()
                            }
                    }
                }
            }
            .persistentSystemOverlays(.hidden)
            .sheet(isPresented: self.$showCharactersMenu){
                CharactersMenuView(backgroundColor: $gameOverBackgroundColor)
            }
            .sheet(isPresented: self.$showLeaderBoard){
                GameCenterLeaderboardView(backgroundColor: $gameOverBackgroundColor)
            }
            .sheet(isPresented: self.$showPlaqueShare){
                PlayersPlaqueView(backgroundColor: $gameOverBackgroundColor)
                    .presentationDetents([.height(450)])
            }
            .sheet(isPresented: self.$showCurrencyPage){
                CurrencyPageView()
            }
            .edgesIgnoringSafeArea(.all)
            .scrollDisabled(freezeScrolling)
            .onAppear {
                notificationManager.registerLocal()
                notificationManager.scheduleLocal()
                checkIfAppOpenToday()
                playedCharacter = appModel.selectedCharacter
                setUpAudioFiles()
                if !GKLocalPlayer.local.isAuthenticated {
                    gameCenter.authenticateUser()
                }
            }
            SnowView()
                .allowsHitTesting(false)
                .ignoresSafeArea()
        }
    }
    
    func setUpAudioFiles() {
        if let music = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3"){
            do {
                self.musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music))
                self.musicPlayer.numberOfLoops = -1
                self.musicPlayer.enableRate = true
                if appModel.mute == true {
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
