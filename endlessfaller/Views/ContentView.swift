//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView
import AudioToolbox
import AVFoundation
import GameKit
import AudioToolbox


let bestScoreKey = "bestscorekey"
let levels = 1000
let difficulty = 8

struct ContentView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    let modelName = UIDevice.modelName
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var appModel = AppModel()
    @ObservedObject private var timerManager = TimerManager()
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
    @State var levelYPosition: CGFloat = 0
    @State var boinIntervalCounter: CGFloat = 900
    @State var highestLevelInRound = -1
    @State var gameOverBackgroundColor: Color = .white
    @State var playedCharacter = ""
    @State private var gameOverTimer: Timer? = nil
    @State var musicPlayer: AVAudioPlayer!
    @State var punchSoundEffect: AVAudioPlayer!
    @State var placeOnLeaderBoard = 0
    @State var isBallButtonMovingUp = false
    @State var isSwipeBannerMovingUp = false
    @State private var circleProgress: CGFloat = 0.0
    @State var colors: [Color] = (1...levels).map { _ in
        Color(hex: backgroundColors.randomElement()!)!
    }
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    func dropBall() {
        timerManager.startTimer(speed: secondsToFall)
    }
    
    func boinFound() {
        showBoinFoundAnimation = true
        appModel.balance += 1
        boinIntervalCounter = 0
    }
    
    func gameOverOperations() {
        if currentIndex == -2 {
            gameOverTimer?.invalidate()
            gameOverTimer = nil
            shouldContinue = true
            costToContinue = 1
            print("gameOverOperations called")
            //currentScore = score
            score = -1
            showContinueToPlayScreen = false
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
            DispatchQueue.main.async{
                gameCenter.updateScore(currentScore: currentScore, bestScore: bestScore, ballID: appModel.selectedCharacter)
            }
        }
    }
    
    func continuePlaying() {
        print("continuePlaying called")
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
        gameOverBackgroundColor = colors[currentIndex]
        DispatchQueue.main.async{
            showContinueToPlayScreen = true
            self.currentIndex = -2
        }
        firstGamePlayed = true
        print("wastedOperations called")
        shouldContinue = false
        highestLevelInRound = -1
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
            
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            self.showWastedScreen = false
            
            timer.invalidate()
        }
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                
            print("calling from wasted operations")
            gameOverOperations()
            self.gameOverTimer?.invalidate()
            self.gameOverTimer = nil
                
        }
    }
    
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    if showContinueToPlayScreen{
                        ZStack{
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
                                                                .font(.title3)
                                                        }
                                                        .padding(.horizontal, 9)
                                                        .padding(.top, 12)
                                                        .padding(.trailing, 21)
                                                        .background(.yellow)
                                                        .cornerRadius(15)
                                                        .overlay{
                                                            RoundedRectangle(cornerRadius: 15)
                                                                .stroke(Color.primary, lineWidth: 3)
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
                                                        .stroke(Color.primary, lineWidth: 6)
                                                        .padding(1)
                                                    ZStack{
                                                        Image(systemName: "stopwatch")
                                                            .bold()
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
                                                        .multilineTextAlignment(.center)
                                                        .foregroundColor(.black)
                                                        .padding()
                                                    Image(systemName: "arrow.up")
                                                        .foregroundColor(.black)
                                                }
                                                .padding(60)
                                                .bold()
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
                        .background(gameOverBackgroundColor)
                        .ignoresSafeArea()
                        .onDisappear{
                            if !shouldContinue{
                                print("calling from screen disappearing")
                                gameOverOperations()
                            }
                        }
                        .tag(-2)
                    }
                    VStack{
                        Spacer()
                        
                        if !firstGamePlayed {
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
                            .tag(-1)
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
                                                        .foregroundColor(.black)
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
                                        AnyView(character.character)
                                            .scaleEffect(2.4)
                                        .offset(x: -70, y: 18)
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
                                .foregroundColor(.primary)
                                .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.1))
                                .tag(-1)
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
                        if firstGamePlayed {
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
//                                        Circle()
//                                            .frame(width: 46)
//                                            .offset(x:  -2, y: 2)
                                        if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                            VStack{
                                                AnyView(character.character)
                                                    
                                                Ellipse()
                                                    .frame(width: 24, height: 6)
                                                    .blur(radius: 3)
                                            }
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
                                        .foregroundColor(.primary)
                                        .padding(36)
                                        .pressEvents {
                                            
                                        } onRelease: {
                                            withAnimation {
                                                showLeaderBoard = true
                                            }
                                        }
//                                    if firstGamePlayed && !modelName.contains("iPhone SE") && !gameCenter.allTimePlayersList.isEmpty {
//                                        HStack{
//                                            Image(systemName: "arrow.down.right")
//                                            Text("Top Score: " + String(gameCenter.allTimePlayersList[0].score))
//                                                .italic()
//                                            Image(systemName: "arrow.down.left")
//                                        }
//                                        .bold()
//                                        .font(idiom == .pad ? .title : .title2)
//                                        .offset(y: -55)
//                                    }
                                }
                            }
                        }
                    }
                    .background(gameOverBackgroundColor)
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            colors[index]
                            if showInstructionsAndBall {
                            if currentIndex == 0 && !showWastedScreen {
                                Instruction()
                                    .scaleEffect(1.5)
                            }
                            if currentIndex == 1 && !showWastedScreen {
                                KeepSwiping()
                                    .scaleEffect(1.5)
                            }
                            if currentIndex >= 2 && currentIndex <= 5 && !showWastedScreen {
                                SwipeFaster()
                                    .scaleEffect(1.5)
                            }
                            if highestLevelInRound == index && !showWastedScreen {
                                GeometryReader { geometry in
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
                                            .frame(width: 66, height: abs(self.timerManager.ballYPosition * 0.1))
                                            .offset(x: 0, y:-(self.timerManager.ballYPosition * 0.1))
                                        }
                                        if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                            let hat = appModel.hats.first(where: { $0.hatID == appModel.selectedHat})
                                            ZStack{
                                                AnyView(character.character)
                                                    .scaleEffect(1.5)
                                                AnyView(hat!.hat)
                                            }
                                            .offset(y: -12)
                                        }
                                    }
                                    .position(x: deviceWidth/2, y: self.timerManager.ballYPosition)
                                    .onChange(of: geometry.frame(in: .global).minY) { newYPosition in
                                        levelYPosition = newYPosition
                                    }
                                }
                            }
                        }
                            if index == 0{
                                ZStack{
                                    Rectangle()
                                        .frame(width: 100, height: 90)
                                        .foregroundColor(gameOverBackgroundColor)
                                    if firstGamePlayed {
                                        PodiumView()
                                            .foregroundColor(.primary)
                                            .offset(y: -9)
                                    }
                                    
                                }
                                .position(x: deviceWidth/2, y: -50)
                                
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
                    gameShouldBeOver = false
                    boinIntervalCounter += 1
                    if boinIntervalCounter > 1000 {
                        boinFound()
                    }
                    if newValue >= highestLevelInRound {
                        score += 1
                        
                    }
//                    if newValue == 0 {
//                    }
                    if newValue > highestLevelInRound {
                        // 1052 or 1054
//                        AudioServicesPlaySystemSound(1052)
                        highestLevelInRound += 1
                        if newValue < 8 {
                            secondsToFall = secondsToFall * fraction
                            fraction += 0.06
                        } else if newValue < 99 {
                            secondsToFall = secondsToFall * 0.981
                        } else {
                            secondsToFall = secondsToFall * 0.999
                        }
                        self.timerManager.ballYPosition = -23
                        dropBall()
                    }
                    impactMed.impactOccurred()
                    if currentIndex > bestScore && currentIndex > 3 {
                        showNewBestScore = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + secondsToFall) {
                        if currentIndex <= newValue && currentIndex >= 0 {
                            gameShouldBeOver = true
                            if levelYPosition >= 0 {
                                wastedOperations()
                            }
                        }
                    }
                }
                .onChange(of: levelYPosition) { yPosition in
                    if yPosition >= 0 && gameShouldBeOver {
                        wastedOperations()
                    }
                }
                .allowsHitTesting(!freezeScrolling)
                if currentIndex >= 0 {
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
//                            Text(String(highestLevelInRound))
//                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if showInstructionsAndBall {
                    if !showNewBestScore {
                        
                        if currentIndex > 100 && currentIndex < 115 {
                            YourGood()
                        }
                        
                        if currentIndex > 200 && currentIndex < 215 {
                            YourInsane()
                        }
                        
                        if currentIndex > 300 && currentIndex < 315 {
                            GoBerzerk()
                        }
                        
                    } else {
                        NewBestScore()
                        CelebrationEffect()
                    }
                    if currentIndex > 70 {
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                BearView()
                            }
                        }
                    }
                    if currentIndex > 20 {
                        ReactionsView()
                            .offset(y: 70)
                    }
                    if currentIndex > 90 {
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
                    
                    if currentIndex > 9 {
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
            //appModel.pickRandomFreeBall()
            playedCharacter = appModel.selectedCharacter
            if let music = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3"){
                do {
                    self.musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: music))
                    self.musicPlayer.numberOfLoops = -1
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
            if !GKLocalPlayer.local.isAuthenticated {
                gameCenter.authenticateUser()
            } else if gameCenter.todaysPlayersList.count == 0 {
                Task{
                    await gameCenter.loadLeaderboard(source: 1)
                }
            }
        }
    }
    
    
    
}

let backgroundColors: [String] = [
    "#FF00FF", // Neon Pink
        "#01FF70", // Bright Green
        "#00FFFF", // Cyan
        "#FF6EFF", // Hot Pink
        "#00FF00", // Lime Green
        "#FF6600", // Neon Orange
        "#33FF00", // Neon Green
        "#FF3300", // Bright Red
        "#FF0099", // Magenta
        "#66FF00", // Bright Yellow-Green
        "#FF0066", // Deep Pink
        "#99FF00", // Chartreuse
        "#FF0000", // Red
        "#00FFCC", // Aqua
        "#FF99CC", // Pinkish
        "#00CCFF", // Sky Blue
        "#FFCC00", // Gold
        "#CC00FF", // Purple
        "#FFFF00", // Yellow
        "#FF99FF", // Pale Pink
        "#0099FF", // Azure
        "#FF6600", // Orange
        "#00FF99", // Mint
        "#FF6699", // Rosy
        "#00FF66", // Spring Green
        "#CCFF00", // Lemon
        "#FF3366", // Rose
        "#00FF33", // Greenish
        "#FF33CC", // Neon Purple
        "#0099CC", // Cerulean
        "#FF0033", // Bright Red
        "#33FFCC", // Turquoise
        "#00CC99", // Peacock Blue
        "#99CC00", // Olive Green
        "#CC66FF", // Lavender
        "#FF6633", // Tangerine
        "#33CCFF", // Light Blue
        "#99FF99", // Light Mint
        "#FF3399", // Deep Rose
        "#0066FF", // Electric Blue
        "#FF9900", // Dark Orange
        "#66FF99", // Aqua Green
        "#FF33FF", // Bright Purple
        "#009966", // Teal
        "#99FF66", // Light Lime
        "#FF0099", // Deep Magenta
        "#66CC00", // Dark Lime
        "#FF66CC", // Light Magenta
        "#00FFCC", // Bright Cyan
        "#66FF33", // Lime
        "#99CCFF", // Pale Blue
        "#FF0066", // Neon Red
        "#33FF99", // Sea Green
        "#CC99FF", // Light Lavender
        "#00FF66", // Light Green
        "#33FF33", // Neon Light Green
        "#FF6633", // Dark Peach
        "#0099FF", // Light Electric Blue
        "#FFCC66", // Peach
        "#66FFCC", // Light Cyan
        "#FF0000", // Neon Red
        "#33CC99", // Dark Cyan
        "#99FF33", // Yellow Green
        "#FF33FF", // Neon Magenta
        "#009966", // Dark Turquoise
        "#99FF66", // Light Yellow Green
        "#FF0099", // Neon Deep Pink
        "#66CC00", // Darker Lime
        "#FF66CC", // Light Neon Pink
        "#00FFCC", // Neon Cyan
        "#66FF33", // Brighter Lime
        "#99CCFF", // Pale Sky Blue
        "#FF0066", // Bright Neon Pink
        "#33FF99", // Light Sea Green
        "#CC99FF", // Pale Lavender
        "#00FF66", // Neon Spring Green
        "#33FF33", // Bright Neon Light Green
        "#FF6633", // Neon Peach
        "#0099FF", // Deep Sky Blue
        "#FFCC66", // Neon Pale Peach
        "#66FFCC", // Neon Light Cyan
        "#FF0000", // Pure Red
        "#33CC99", // Dark Sea Green
        "#99FF33", // Light Neon Lime
        "#FF33FF", // Neon Violet
        "#009966", // Forest Green
        "#99FF66", // Pale Neon Lime
        "#FF0099", // Neon Rose
        "#66CC00", // Grass Green
        "#FF66CC", // Neon Pale Pink
        "#00FFCC", // Bright Turquoise
        "#66FF33", // Spring Lime
        "#99CCFF", // Daylight Blue
        "#FF0066", // Neon Fuchsia
        "#33FF99"  // Fresh Green
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
