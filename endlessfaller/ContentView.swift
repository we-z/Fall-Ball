//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView

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
    @State var showScreen = false
    
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
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    ZStack{
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Button {
                                    showScreen = true
                                } label: {
                                    Image(systemName: "cart")
                                        .foregroundColor(.primary)
                                        .bold()
                                        .font(.largeTitle)
                                        .padding(36)
                                }
                            }
                            
                        }
                        if !gameOver {
                            VStack{
                                Text("Swipe up \nto play")
                                    .multilineTextAlignment(.center)
                                    .padding()
                                Image(systemName: "arrow.up")
                            }
                            .bold()
                            .font(.largeTitle)
                            .tag(-1)
                        } else {
                            
                            VStack{
                                Text("Game Over")
                                    .bold()
                                    .font(.largeTitle)
                                ZStack{
                                    Rectangle()
                                        .foregroundColor(.primary.opacity(0.1))
                                        .cornerRadius(30)
                                    HStack{
                                        VStack(alignment: .leading){
                                            Text("Score")
                                            Text(String(currentScore))
                                                .padding(.bottom, 3)
                                            Text("Best")
                                            Text(String(bestScore))
                                        }
                                        .padding(.leading, 50)
                                        .bold()
                                        .font(.largeTitle)
                                        Spacer()
                                        VStack{
                                            Text("Ball")
                                                .bold()
                                                .font(.title2)
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
                                        .multilineTextAlignment(.center)
                                        .padding()
                                    Image(systemName: "arrow.up")
                                }
                                .foregroundColor(.primary)
                                .bold()
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
                                AnyView(character.character)
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
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                        if currentIndex <= newValue && currentIndex != -1 {
                            gameOver = true
                            currentScore = highestScoreInGame
                            if currentScore > bestScore {
                                bestScore = currentScore
                                UserDefaults.standard.set(bestScore, forKey: bestScoreKey)
                            }
                            freezeScrolling = true
                            highestScoreInGame = 0
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
                                .font(.system(size: 60))
                                .bold()
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
            }
        }
        .sheet(isPresented: self.$showScreen){
               CharactersMenuView()
                   .presentationDetents([.medium])
                   .presentationDragIndicator(.visible)
        }
        .edgesIgnoringSafeArea(.all)
        .allowsHitTesting(!freezeScrolling)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
