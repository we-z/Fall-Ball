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
    @State var speed: Double = 4
    @State var fraction: Double = 0.5
    @State var gameOver = false
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
    @State var levelYPosition: CGFloat = 0
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
        timerManager.startTimer(speed: speed)
    }
    
    func gameOverOperations() {
        gameOverTimer?.invalidate()
        gameOverTimer = nil
        shouldContinue = true
        costToContinue = 1
        print("gameOverOperations called")
        currentScore = score
        score = -1
        showContinueToPlayScreen = false
        showInstructionsAndBall = true
        freezeScrolling = false
        gameOver = true
        
        if currentScore > bestScore {
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
            DispatchQueue.main.async{
                bestScore = currentScore
            }
        }
        //DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.speed = 4
        self.fraction = 0.5
        circleProgress = 0.0
        //}
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
        freezeScrolling = false
        gameOver = true
        self.speed = 4
        self.fraction = 0.5
        currentIndex = 0
    }
    
    func wastedOperations() {
        print("wastedOperations called")
        shouldContinue = false
        highestLevelInRound = -1
        circleProgress = 0.0
        showInstructionsAndBall = false
        self.punchSoundEffect.play()
        gameOverBackgroundColor = colors[currentIndex]
        showNewBestScore = false
        gameOver = true
        freezeScrolling = true
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        showWastedScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(hex: backgroundColors.randomElement()!)!
            }
            freezeScrolling = false
            self.speed = 4
            self.fraction = 0.5
            
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            
            self.showWastedScreen = false
            showContinueToPlayScreen = true
            self.currentIndex = -2
            timer.invalidate()
        }
        gameOverTimer = Timer.scheduledTimer(withTimeInterval: 7, repeats: false) { timer in
                
                //            DispatchQueue.main.async{
                //                gameCenter.updateScore(currentScore: currentScore, bestScore: bestScore, ballID: appModel.selectedCharacter)
                //            }
                
                //self.currentIndex = -1
                
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
                                            .onAppear{
                                                withAnimation(.linear(duration: 6)) {
                                                    circleProgress = 1.0
                                                }
                                            }
                                            
                            //                Circle()
                            //                    .foregroundColor(.clear)
                            //            }
                            //            .frame(
                            //                width: deviceWidth,
                            //                height: deviceHeight
                            //            )
                            //            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                            //            .edgesIgnoringSafeArea(.all)
                            //            .onChange(of: currentIndex) { index in
                            //                appModel.cancelContinuation = true
                            //            }
                                        
                                    }
                                    .sheet(isPresented: self.$showCurrencyPage){
                                        CurrencyPageView()
                                    }
                                    Spacer()
                                }
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
                        
                        if !gameOver {
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
                                        Color.white
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
                        if gameOver {
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
                                    if gameOver && !modelName.contains("iPhone SE") && !gameCenter.allTimePlayersList.isEmpty {
                                        HStack{
                                            Image(systemName: "arrow.down.right")
                                            Text("Top Score: " + String(gameCenter.allTimePlayersList[0].score))
                                                .italic()
                                            Image(systemName: "arrow.down.left")
                                        }
                                        .bold()
                                        .font(idiom == .pad ? .title : .title2)
                                        .offset(y: -55)
                                    }
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
                                            AnyView(character.character)
                                                .scaleEffect(1.5)
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
                                    if gameOver {
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
                    print("newValue: \(newValue)")
                    gameShouldBeOver = false
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
                            speed = speed * fraction
                            fraction += 0.06
                        } else if newValue < 99 {
                            speed = speed * 0.981
                        } else {
                            speed = speed * 0.999
                        }
                        self.timerManager.ballYPosition = -23
                        dropBall()
                    }
                    impactMed.impactOccurred()
                    if currentIndex > bestScore && currentIndex > 3 {
                        showNewBestScore = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
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
                        //wastedOperations()
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
                            Text(String(highestLevelInRound))
                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if showWastedScreen {
                    WastedView()
                } else{
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
                        }
                        if currentIndex > 10 {
                            CelebrationEffect()
                        }
                        if currentIndex > 40 {
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
                        if currentIndex > 60 {
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
                        
                        if currentIndex > 33 {
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
        //.scrollDisabled(freezeScrolling)
        .onAppear {
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
    "#FFD700", "#FFC0CB", "#FF6347", "#ADFF2F", "#FAEBD7",
    "#FFA07A", "#98FB98", "#F0E68C", "#FFB6C1", "#F5DEB3",
    "#ADD8E6", "#DDA0DD", "#E0FFFF", "#AFEEEE", "#FFDEAD",
    "#D3D3D3", "#FFDAB9", "#B0E0E6", "#FFE4B5", "#FFEFDB",
    "#C1FFC1", "#FFBFFF", "#B5E4FF", "#FFCC99", "#B4EEB4",
    "#FFEBCC", "#EED2EE", "#FFD8AA", "#D6E0F0", "#F0E6C0",
    "#FFD3E0", "#E3E3E3", "#FFF0D9", "#D0F0C0", "#FCE5CD",
    "#D9EAD3", "#EAD1DC", "#F9CB9C", "#FFE599", "#B6D7A8",
    "#D5AEDD", "#A2C4C9", "#FAF0E6", "#ECE0D1", "#F4C2C2",
    "#FDE5BD", "#F6BCA9", "#FFF2CC", "#D9E3F0", "#E6D9EC",
    "#FFE6CC", "#F6E0B5", "#D0E3E4", "#C9DAF8", "#C3D7A5",
    "#EA9999", "#F5D5A0", "#B4A7D6", "#D5E2A2", "#B7DDE8",
    "#FFDBDB", "#FFEBE6", "#E6B8B7", "#F9E0D3", "#FCE4D6",
    "#FFF1D4", "#EADFC6", "#E5E0EC", "#C6D9F0", "#A4C2F4",
    "#C27BA0", "#FFD966", "#93CDDD", "#76A5AF", "#A5A5A5",
    "#FFC000", "#DA9694", "#B7B7B7", "#FFB2B2", "#D99795",
    "#E5B8B7", "#D5A6BD", "#FABF8F", "#C4D79B", "#9BBB59",
    "#FFE6E6", "#FCD5B4", "#E5A4A4", "#D8A8A8", "#C0504D"
]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
