//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView
import AudioToolbox
import AVKit

let bestScoreKey = "BestScore"

struct ContentView: View {
    
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @StateObject var model = AppModel()
    @State var score: Int = 0
    @State var highestScoreInGame: Int = 0
    @State var currentScore: Int = 0
    @State var currentIndex: Int = -1
    @State var speed: Double = 2
    @State var isAnimating = false
    @State var gameOver = false
    @State var freezeScrolling = false
    @State var showCharactersMenu = false
    @State var mute = false
    @State var showGameOver = false
    
    @State var audioPlayer: AVAudioPlayer!
    
    @State var colors: [Color] = (1...1000).map { _ in
        Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
    }
    
    func dropCircle() {
        withAnimation(
            Animation.linear(duration: speed)
        ) {
            isAnimating = true
        }
    }
    
    let impactMed = UIImpactFeedbackGenerator(style: .medium)
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    ZStack{
                        VStack{
                            Spacer()
                            HStack{
                                Button {
                                    mute.toggle()
                                } label: {
                                    Image(systemName: mute ? "speaker.slash" : "speaker.wave.2")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                                .onChange(of: mute) { setting in
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
                                    Image(systemName: "cart")
                                        .foregroundColor(.primary)
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                            }
                        }
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
                            .tag(-1)
                            .blinking()
                        } else {
                            VStack{
                                Text("Game Over")
                                    .bold()
                                    .italic()
                                    .font(.largeTitle)
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.primary.opacity(0.1))
                                        .cornerRadius(30)
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text("Score")
                                                .bold()
                                                .italic()
                                            Text(String(currentScore))
                                                .padding(.bottom, 3)
                                            Text("Best")
                                                .bold()
                                                .italic()
                                            Text(String(bestScore))
                                        }
                                        .padding(.leading, 50)
                                        .font(.largeTitle)
                                        Spacer()
                                        VStack{
                                            Text("Ball")
                                                .bold()
                                                .italic()
                                                .font(.title)
                                            let character = model.characters[model.selectedCharacter]
                                            AnyView(character.character)
                                        }
                                        .offset(y: -(UIScreen.main.bounds.height * 0.02))
                                        .padding(.trailing, 60)
                                    }
                                }
                                .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height * 0.3)
                                
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
                            .offset(y: UIScreen.main.bounds.height * 0.05)
                        }
                    }
                    let character = model.characters[model.selectedCharacter]
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            if highestScoreInGame == index {
                                ZStack{
                                    VStack{
                                        LinearGradient(
                                            colors: [.gray.opacity(0.01), .gray.opacity(0.75)],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    }
                                    .frame(width: 46, height: 60)
                                    .offset(x: 0, y:-23)
                                    AnyView(character.character)
                                }
                                .position(x: UIScreen.main.bounds.width/2, y: isAnimating ? UIScreen.main.bounds.height - 23 : -23)
                            }
                            if index == 0{
                                Rectangle()
                                    .frame(width: 100, height: 100)
                                    .foregroundColor(.white)
                                    .position(x: UIScreen.main.bounds.width/2, y: -50)
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
                    if newValue > 0{
                        gameOver = true
                    }
                    score = newValue
                    if newValue >= highestScoreInGame {
                        highestScoreInGame = newValue
                        if currentIndex < 21 {
                            speed = 2.0 / ((Double(newValue) / 3) + 1)
                        }
                        isAnimating = false
                        dropCircle()
                    }
                    impactMed.impactOccurred()
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                        if currentIndex <= newValue && currentIndex != -1 {
                            gameOver = true
                            currentScore = highestScoreInGame
                            if currentScore > bestScore {
                                bestScore = currentScore
                                UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                            }
                            freezeScrolling = true
//                            showGameOver = true
//                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
//                            sleep(1)
//                            showGameOver = false
                            highestScoreInGame = 0
                            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
//                            DispatchQueue.main.async {
//                                currentIndex = -1
//                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.colors = (1...1000).map { _ in
                                    Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
                                }
                                freezeScrolling = false
                            }
                            currentIndex = -1
                        }
                    }
                }
                
                if currentIndex >= 0 {
                    VStack{
                        HStack{
                            Text(String(score))
                                .font(.system(size: 90))
                                .padding(36)
                                .padding(.top, 30)
                            Spacer()
//                            Text(String(speed))
//                                .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }
                
                if currentIndex >= 0 && currentIndex < 2 {
                    KeepSwiping()
                }
                
                if currentIndex > 30 && currentIndex < 45 {
                    KeepGoing()
                }
                
                if currentIndex > 100 && currentIndex < 115 {
                    YourGood()
                }
                
                if currentIndex > 21 {
                    VStack{
                        Spacer()
                        HStack{
                            Spacer()
                            SVGCharacterView()
                                .padding(60)
                        }
                    }
                    .allowsHitTesting(false)
                }
                
                if currentIndex > 200 && currentIndex < 215 {
                    YourInsane()
                }
                
                if currentIndex > 300 && currentIndex < 315 {
                    GoBerzerk()
                }
            }
        }
        .sheet(isPresented: self.$showCharactersMenu){
               CharactersMenuView()
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(!freezeScrolling)
        .onAppear {
            let sound = Bundle.main.path(forResource: "FallBallOST120", ofType: "mp3")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            self.audioPlayer.numberOfLoops = 1000
            self.audioPlayer.play()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
