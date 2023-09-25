//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView
import AudioToolbox
import CloudKit
import AVFoundation


let bestScoreKey = "bestscorekey"
let levels = 1000
let difficulty = 6

struct ContentView: View {
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    let modelName = UIDevice.modelName
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var appModel = AppModel()
    @StateObject private var CKVM = CloudKitCrud()
    @ObservedObject private var timerManager = TimerManager()
    @State var score: Int = 0
    @State var highestScoreInGame: Int = -1
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var speed: Double = 4
    @State var gameOver = false
    @State var freezeScrolling = false
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var showNewBestScore = false
    @State var gameShouldBeOver = false
    @State var showWastedScreen = false
    @State var muteIsPressed = false
    @State var ballButtonIsPressed = false
    @State var levelYPosition: CGFloat = 0
    @State var gameOverBackgroundColor: Color = .white
    @State var playedCharacter = ""
    @State var musicPlayer: AVAudioPlayer!
    @State var punchSoundEffect: AVAudioPlayer!
    @State var placeOnLeaderBoard = 0
    @State var recordID: CKRecord.ID? = nil
    @State var colors: [Color] = (1...levels).map { _ in
        Color(red: .random(in: 0.4...1), green: .random(in: 0.4...1), blue: .random(in: 0.4...1))
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
        self.punchSoundEffect.play()
        gameOverBackgroundColor = colors[currentIndex]
        showNewBestScore = false
        gameOver = true
        currentScore = highestScoreInGame
        if currentScore > bestScore {
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
            DispatchQueue.main.async{
                bestScore = currentScore
                CKVM.updateRecord(newScore: bestScore, newCharacterID: appModel.selectedCharacter)
            }
        }
        freezeScrolling = true
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        showWastedScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(red: .random(in: 0.3...1), green: .random(in: 0.3...1), blue: .random(in: 0.3...1))
            }
            freezeScrolling = false
            self.speed = 4
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            showWastedScreen = false
            self.currentIndex = -1
            highestScoreInGame = -1
            CKVM.updateRecord(newScore: bestScore, newCharacterID: appModel.selectedCharacter)
            timer.invalidate() // Stop the timer after the reset
        }
    }
    
    let impactMed = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    VStack{
                        Spacer()
                        if !gameOver {
                            VStack{
                                Text("Swipe up \nto play!")
                                    .bold()
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                    .padding()
                                Image(systemName: "arrow.up")
                                    .foregroundColor(.black)
                            }
                            .font(.largeTitle)
                            .scaleEffect(1.5)
//                            .flashing()
                            .tag(-1)
                            .offset(y: deviceHeight * 0.08)
                        } else {
                            VStack{
                                Text("Game Over!")
                                    .italic()
                                    .bold()
                                    .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.08))
                                    .foregroundColor(.black)
                                    .scaleEffect(1.8)
                                    .padding(.bottom, deviceHeight * 0.03)
                                ZStack{
                                    HStack{
                                        VStack(alignment: .trailing){
                                            Spacer()
                                                .frame(maxHeight: 10)
                                            HStack{
                                                ZStack{
                                                    Text("Ball:")
                                                        .font(.largeTitle)
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
                                                .offset(y: 6)
                                                .foregroundColor(.black)
                                            Spacer()
                                                .frame(maxHeight: 15)
                                            Text("Best:")
                                                .foregroundColor(.black)
                                                .bold()
                                                .italic()
                                            Text(String(bestScore))
                                                .bold()
                                                .offset(y: 6)
                                                .foregroundColor(.black)
                                            Spacer()
                                                .frame(maxHeight: 10)
                                        }
                                        .padding(.trailing, 30)
                                        .padding()
                                        .font(.largeTitle)
                                    }
                                    if let character = appModel.characters.first(where: { $0.characterID == playedCharacter}) {
                                        AnyView(character.character)
                                        .scaleEffect(2)
                                        .offset(x: -80, y: 15)
                                    }
                                }
                                .background{
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.white)
                                            .cornerRadius(30)
                                            .shadow(color: .black, radius: 9, x: 0, y: 6)
                                            .padding(.horizontal,9)
                                        LinearGradient(
                                            colors: [.white, .white, .gray.opacity(0.1)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                        .cornerRadius(30)
                                        .padding(.horizontal,9)
                                    }

                                }
                                VStack{
                                    Text("Swipe up to \nplay again!")
                                        .bold()
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .padding(.top, deviceHeight * 0.02)
                                        .padding()
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.black)
                                        //.shadow(color: .black, radius: 3)
                                }
                                .foregroundColor(.primary)
                                .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.09))
                                .scaleEffect(1.2)
                                .tag(-1)
                            }
                            .offset(y: deviceHeight * 0.09)
                        }
                        Spacer()
                        ZStack{
                            HStack{

                            Image(systemName: appModel.mute ? "speaker.slash" : "speaker.wave.2")
                                .foregroundColor(.black)
                                .font(.largeTitle)
                                //.shadow(color: .black, radius: 0.5, x: muteIsPressed ? 0 : -3, y: muteIsPressed ? 0 : 3)
                                .scaleEffect(1.2)
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
                                        AnyView(character.character)
                                            .offset(x: ballButtonIsPressed ? -3 : 0, y: ballButtonIsPressed ? 3 : 0)
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
                                            CKVM.fetchItems()
                                        }
                                    }
                                if gameOver && !modelName.contains("iPhone SE") && !CKVM.scores.isEmpty {
                                    HStack{
                                        Image(systemName: "arrow.down.right")
                                        Text("Top Score: " + String(CKVM.scores[0].bestScore))
                                            .bold()
                                            .italic()
                                        Image(systemName: "arrow.down.left")
                                    }
                                    .font(idiom == .pad ? .title : .title2)
                                    .offset(y: -55)
                                }
                            }
                        }
                    }
                    
                    .background(gameOverBackgroundColor)
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            colors[index]
                            if currentIndex == 0 && !showWastedScreen {
                                Instruction()
                                    .scaleEffect(1.5)
                            }
                            if currentIndex == 1 && !showWastedScreen {
                                KeepSwiping()
                                    .scaleEffect(1.5)
                            }
                            if currentIndex == 2 && !showWastedScreen {
                                SwipeFaster()
                                    .scaleEffect(1.5)
                            }
                            if highestScoreInGame == index && !showWastedScreen {
                                GeometryReader { geometry in
                                    ZStack{
                                        if !gameShouldBeOver{
                                            withAnimation(.easeInOut(duration: 0.1)) {
                                                VStack{
                                                    LinearGradient(
                                                        colors: [.gray.opacity(0.01), .white],
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                }
                                                .frame(width: 44, height: 60)
                                                .offset(x: 0, y:-27)
                                            }
                                        }
                                        if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                                            AnyView(character.character)
                                        }
                                    }
                                    .position(x: deviceWidth/2, y: self.timerManager.ballYPosition)
                                    .onChange(of: geometry.frame(in: .global).minY) { newYPosition in
                                        levelYPosition = newYPosition
                                    }
                                }
                            }
                            if index == 0{
                                ZStack{
                                    Rectangle()
                                        .frame(width: 100, height: 90)
                                        .foregroundColor(gameOverBackgroundColor)
                                    PodiumView()
                                        .foregroundColor(.primary)
                                        .offset(y: -9)
                                    
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
                    score = newValue
                    if score > highestScoreInGame {
                        highestScoreInGame = score
                        if newValue < difficulty {
                            speed = speed / 2
                        }
                        self.timerManager.ballYPosition = -23
                        dropBall()
                    }
                    impactMed.impactOccurred()
                    if currentIndex > bestScore && currentIndex > 3 {
                        showNewBestScore = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                        if currentIndex <= newValue && currentIndex != -1 {
                            gameShouldBeOver = true
                            if levelYPosition >= 0 {
                                gameOverOperations()
                            }
                        }
                    }
                }
                .onChange(of: levelYPosition) { yPosition in
                    if yPosition >= 0 && gameShouldBeOver {
                        gameOverOperations()
                    }
                }
                if currentIndex >= 0 {
                    VStack{
                        HStack{
                            Text(String(score))
                                .font(.system(size: 90))
                                .padding(36)
                                .padding(.top, 30)
                                .foregroundColor(.black)
                            Spacer()
//                            Text("\(self.speed)")
//                                .foregroundColor(.black)
//                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if showWastedScreen {
                    ZStack{
                        WastedView()
                    }
                } else{
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
        .sheet(isPresented: self.$showCharactersMenu){
            CharactersMenuView()
        }
        .sheet(isPresented: self.$showLeaderBoard){
            LeaderBoardView()
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(!freezeScrolling)
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
                    if appModel.mute == true {
                        self.punchSoundEffect.setVolume(0, fadeDuration: 0)
                    } else {
                        self.punchSoundEffect.setVolume(1, fadeDuration: 0)
                    }
                } catch {
                    print("Error playing audio: \(error)")
                }
            }
            CKVM.fetchItems()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
