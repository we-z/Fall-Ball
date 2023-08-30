//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView
import AudioToolbox
//import AVKit
import AVFoundation


let bestScoreKey = "BestScore"
let levels = 1000

struct ContentView: View {
    
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var appModel = AppModel()
    @StateObject private var ckvm = CloudKitCrud()
    @State var score: Int = 0
    @State var highestScoreInGame: Int = 0
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var speed: Double = 2
    @State var isAnimating = false
    @State var gameOver = false
    @State var freezeScrolling = false
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var showGameOver = false
    @State var showNewBestScore = false
    @State var gameShouldBeOver = false
    @State var levelYPosition: CGFloat = 0
    @State var playedCharacter = 0
    @State var audioPlayer: AVAudioPlayer!
    
    @State var colors: [Color] = (1...levels).map { _ in
        Color(red: .random(in: 0.3...1), green: .random(in: 0.3...1), blue: .random(in: 0.3...1))
    }
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting up audio session: \(error)")
        }
    }
    
    func dropCircle() {
        withAnimation(
            Animation.linear(duration: speed)
        ) {
            isAnimating = true
        }
    }
    
    func gameOverOperations() {
        showNewBestScore = false
        gameOver = true
        currentScore = highestScoreInGame
        if currentScore > bestScore {
            bestScore = currentScore
            UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
        }
        freezeScrolling = true
        highestScoreInGame = 0
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {
            self.currentIndex = -1
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(red: .random(in: 0.3...1), green: .random(in: 0.3...1), blue: .random(in: 0.3...1))
            }
            freezeScrolling = false
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        Timer.scheduledTimer(withTimeInterval: 0, repeats: false) { timer in
            self.currentIndex = -1
            timer.invalidate() // Stop the timer after the reset
        }
        ckvm.updateRecord(newScore: bestScore, newCharacterID: appModel.characters[appModel.selectedCharacter].characterID)
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
                                Text("Swipe up \nto play")
                                    .bold()
                                    .italic()
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Image(systemName: "arrow.up")
                            }
                            .font(.largeTitle)
                            .scaleEffect(1.5)
                            .blinking()
                            .tag(-1)
                            .offset(y: UIScreen.main.bounds.height * 0.07)
                        } else {
                            ZStack{
//                                HStack{
//                                    Text("🏆 #3 place 🌍")
//                                        .bold()
//                                        .italic()
//                                }
//                                .font(.largeTitle)
//                                .padding(.bottom)
//                                .offset(y: -UIScreen.main.bounds.height * 0.39)
                                VStack{
                                                                    
                                    Text("Game Over!")
                                        .italic()
                                        .bold()
                                        .font(.largeTitle)
                                        .scaleEffect(1.5)
                                    ZStack{
                                        Rectangle()
                                            .foregroundColor(.primary.opacity(0.12))
                                            .cornerRadius(30)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(Color.primary, lineWidth: 2)
                                            )
                                        HStack{
                                            VStack{
                                                Text("Ball")
                                                    .font(.largeTitle)
                                                    .bold()
                                                    .italic()
                                                    .font(.title)
                                                let character = appModel.characters[playedCharacter]
                                                AnyView(character.character)
                                                    .scaleEffect(2)
                                                    .padding(.top)
                                            }
                                            .offset(y: -(UIScreen.main.bounds.height * 0.02))
                                            .padding(.leading, UIScreen.main.bounds.width * 0.12)
                                            Spacer()
                                            VStack(alignment: .trailing){
                                                Spacer()
                                                Text("Score")
                                                //.foregroundColor(.blue)
                                                    .bold()
                                                    .italic()
                                                Text(String(currentScore))
                                                Spacer()
                                                Text("Best")
                                                //.foregroundColor(.blue)
                                                    .bold()
                                                    .italic()
                                                Text(String(bestScore))
                                                Spacer()
                                            }
                                            .padding(.trailing, UIScreen.main.bounds.width * 0.07)
                                            .padding()
                                            .font(.largeTitle)
                                        }
                                    }
                                    .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.27)
                                    
                                    VStack{
                                        Text("Swipe up to \nplay again")
                                            .bold()
                                            .italic()
                                            .multilineTextAlignment(.center)
                                            .padding()
                                        Image(systemName: "arrow.up")
                                    }
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                                    .tag(-1)
                                }
                            }
                            .offset(y: UIScreen.main.bounds.height * 0.1)
                        }
                        Spacer()
                        ZStack{
                            HStack{
                                Button {
                                    appModel.mute.toggle()
                                } label: {
                                    Image(systemName: appModel.mute ? "speaker.slash" : "speaker.wave.2")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                                .onChange(of: appModel.mute) { setting in
                                    if setting == true {
                                        self.audioPlayer.setVolume(0, fadeDuration: 0)
                                    } else {
                                        self.audioPlayer.setVolume(1, fadeDuration: 0)
                                    }
                                }
                                Spacer()
                                Button {
                                    showCharactersMenu = true
                                } label: {
                                    Image(systemName: "person.crop.circle")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                            }
                            Button {
                                showLeaderBoard = true
                            } label: {
                                Image(systemName: "list.bullet")
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                                    .padding(36)
                            }
                        }
                    }
                    let character = appModel.characters[appModel.selectedCharacter]
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            if highestScoreInGame == index {
                                GeometryReader { geometry in
                                    ZStack{
                                        if !gameShouldBeOver{
                                            VStack{
                                                LinearGradient(
                                                    colors: [.gray.opacity(0.01), .white],
                                                    startPoint: .top,
                                                    endPoint: .bottom
                                                )
                                            }
                                            .frame(width: 46, height: 50)
                                            .offset(x: 0, y:-25)
                                        }
                                        AnyView(character.character)
                                    }
                                    .position(x: UIScreen.main.bounds.width/2, y: isAnimating ? UIScreen.main.bounds.height - 23 : -27)
                                    .onChange(of: geometry.frame(in: .global).minY) { newYPosition in
                                        levelYPosition = newYPosition
                                    }
                                }
                            }
                            if index == 0{
                                ZStack{
                                    Rectangle()
                                        .frame(width: 100, height: 80)
                                        .foregroundColor(.primary)
                                        .colorInvert()
                                    Image(systemName: "list.bullet")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .offset(y: -15)
                                    
                                }
                                .position(x: UIScreen.main.bounds.width/2, y: -40)
                                
                            }
                            if currentIndex == 0 {
                                KeepSwiping()
                            }
                            if currentIndex == 1 {
                                Instruction()
                            }
                        }
                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentIndex) { newValue in
                    gameShouldBeOver = false
                    if newValue > 0{
                        gameOver = true
                    }
                    score = newValue
                    if score > highestScoreInGame || score == 0 {
                        highestScoreInGame = score
                        if currentIndex < 36 {
                            speed = 2.0 / ((Double(newValue) / 3) + 1)
                        }
                        isAnimating = false
                        dropCircle()
                    }
                    impactMed.impactOccurred()
                    if currentIndex > bestScore && currentIndex > 3 {
                        showNewBestScore = true
                    }
                    if currentIndex == colors.count - 1{
                        colors += (1...levels).map { _ in
                            Color(red: .random(in: 0.3...1), green: .random(in: 0.3...1), blue: .random(in: 0.3...1))
                        }
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
//                            Text("\(self.levelYPosition)")
//                                .foregroundColor(.black)
//                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if !showNewBestScore {
                    
                    if currentIndex > 21 && currentIndex < 33 {
                        KeepGoing()
                    }
                    
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
                    CelebrationEffect()
                    NewBestScore()
                }
                
                if currentIndex > 315 {
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            BearView()
                        }
                    }
                }
                if currentIndex > 115 {
                    ReactionsView()
                        .offset(y: 70)
                }
                
                if currentIndex > 215 {
                    VStack{
                        Spacer()
                        HStack{
                            SwiftUIXmasTree2()
                                .scaleEffect(0.5)
                                .offset(x:-UIScreen.main.bounds.width/10)
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
                                .offset(x:UIScreen.main.bounds.width/10)
                        }
                    }
                    .allowsHitTesting(false)
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
            if let sound = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3"){
                do {
                    self.audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound))
                    self.audioPlayer.numberOfLoops = -1
                    if appModel.mute == true {
                        self.audioPlayer.setVolume(0, fadeDuration: 0)
                    } else {
                        self.audioPlayer.setVolume(1, fadeDuration: 0)
                    }
                    self.audioPlayer.play()
                } catch {
                    print("Error playing audio: \(error)")
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
