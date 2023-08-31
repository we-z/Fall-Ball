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
    @State var highestScoreInGame: Int = -1
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var speed: Double = 2
    @State var isAnimating = false
    @State var gameOver = false
    @State var freezeScrolling = false
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var showNewBestScore = false
    @State var gameShouldBeOver = false
    @State var showWastedScreen = false
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
        highestScoreInGame = -1
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        showWastedScreen = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.colors = (1...levels).map { _ in
                Color(red: .random(in: 0.3...1), green: .random(in: 0.3...1), blue: .random(in: 0.3...1))
            }
            freezeScrolling = false
        }
        gameShouldBeOver = false
        self.playedCharacter = appModel.selectedCharacter
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
            showWastedScreen = false
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
                                    .foregroundColor(.green)
                            }
                            .font(.largeTitle)
                            .scaleEffect(1.5)
                            .flashing()
                            .tag(-1)
                            .offset(y: UIScreen.main.bounds.height * 0.06)
                        } else {
                            VStack{
                                Text("Game Over!")
                                    .underline(color: .red)
                                    .italic()
                                    .bold()
                                    .font(.largeTitle)
                                    .scaleEffect(1.8)
                                    .padding(.bottom, 30)
//                                HStack{
//                                    Text("❌ No Score board")
//                                        .italic()
//                                        .bold()
//                                        .font(.title)
//                                        .padding(.bottom, 6)
//                                    PodiumView()
//                                        .scaleEffect(0.6)
//                                        .offset(x: -6, y: -3)
//                                }
                                .offset(x: 6)
                                    HStack{
                                        VStack{
                                            Text("Ball:")
                                                .underline()
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
                                            .frame(maxWidth: 75)
                                        VStack(alignment: .trailing){
                                            Spacer()
                                                .frame(maxHeight: 10)
                                            Text("Score:")
                                                .underline()
                                            //.foregroundColor(.blue)
                                                .bold()
                                                .italic()
                                            Text(String(currentScore))
                                                .bold()
                                                .offset(y: 6)
                                            Spacer()
                                                .frame(maxHeight: 18)
                                            Text("Best:")
                                                .underline()
                                            //.foregroundColor(.blue)
                                                .bold()
                                                .italic()
                                            Text(String(bestScore))
                                                .bold()
                                                .offset(y: 6)
                                            Spacer()
                                                .frame(maxHeight: 10)
                                        }
                                        .padding(.trailing, UIScreen.main.bounds.width * 0.07)
                                        .padding()
                                        .font(.largeTitle)
                                    }
                                    .background{
                                        Rectangle()
                                            .foregroundColor(.primary.opacity(0.15))
                                            .cornerRadius(30)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 30)
                                                    .stroke(Color.yellow, lineWidth: 3)
                                            )
                                            .padding(.horizontal,9)
                                    }
                                VStack{
                                    Text("Swipe up to \nplay again")
                                        .bold()
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding()
                                    Image(systemName: "arrow.up")
                                        .foregroundColor(.green)
                                }
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                                .scaleEffect(1.2)
                                .tag(-1)
                            }
                            .offset(y: UIScreen.main.bounds.height * 0.075)
                        }
                        Spacer()
                        ZStack{
                            HStack{
                                Button {
                                    appModel.mute.toggle()
                                } label: {
                                    Image(systemName: appModel.mute ? "speaker.slash.fill" : "speaker.wave.2.fill")
                                        .foregroundColor(.teal)
                                        .font(.largeTitle)
                                        .scaleEffect(1.2)
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
                                    ZStack{
                                        Image(systemName: "circle.fill")
                                            .foregroundColor(.red)
                                    }
                                        .font(.largeTitle)
                                        .scaleEffect(1.4)
                                        .padding(36)
                                }
                            }
                            Button {
                                showLeaderBoard = true
                            } label: {
                                PodiumView()
                                    .foregroundColor(.primary)
                                    .font(.largeTitle)
                                    .scaleEffect(1.0)
                                    .padding(36)
                            }
                        }
                    }
                    let character = appModel.characters[appModel.selectedCharacter]
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            if highestScoreInGame == index && !showWastedScreen {
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
                                            .frame(width: 44, height: 45)
                                            .offset(x: 0, y:-23)
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
                                    PodiumView()
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .offset(y: -15)
                                    
                                }
                                .position(x: UIScreen.main.bounds.width/2, y: -40)
                                
                            }
                            if currentIndex == 0 && !gameOver {
                                KeepSwiping()
                            }
                            if currentIndex == 1 && !gameOver {
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
                    if currentIndex != -1{
                        gameOver = false
                    }
                    gameShouldBeOver = false
                    score = newValue
                    if score > highestScoreInGame {
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
                
                if showWastedScreen {
                    ZStack{
                        Color.red.opacity(0.5)
                            .strobing()
                        WastedView()
                    }
                } else{
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
