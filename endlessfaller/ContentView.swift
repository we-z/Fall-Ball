//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView

struct ContentView: View {
    
    @State var score: Int = 0
    @State var currentScore: Int = 0
    @State var best: Int = 0
    @State var currentIndex: Int = -1
    @State var isAnimating = false
    @State var firstScreen = true
    @State var gameOver = false
    @State var speed: Double = 2
    
    @State var colors: [Color] = (1...1000).map { _ in
        Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
    }
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
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
                                        Text(String(best))
                                    }
                                    .padding(.leading, 50)
                                    .bold()
                                    .font(.largeTitle)
                                    Spacer()
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
                    
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            Circle()
                                .allowsHitTesting(false)
                                .frame(width: 46)
                                .colorInvert()
                                .position(x: UIScreen.main.bounds.width/2, y: isAnimating ? UIScreen.main.bounds.height - 23 : -23)
                            
                        }
                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentIndex) { newValue in
                    gameOver = true
                    firstScreen = false
                    score = newValue
                    speed = 2.0 / ((Double(newValue) / 39) + 1)
                    self.isAnimating = false
                    dropCircle()
                    DispatchQueue.main.asyncAfter(deadline: .now() + speed) {
                        if currentIndex <= newValue && currentIndex != -1 {
                            currentScore = score
                            if currentScore > best {
                                best = currentScore
                            }
                            self.isAnimating = false
                            self.colors = (1...1000).map { _ in
                                Color(red: .random(in: 0.3...0.7), green: .random(in: 0.3...0.9), blue: .random(in: 0.3...0.9))
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
                            //                        Text(String(speed))
                            //                            .padding()
                        }
                        Spacer()
                    }
                    .allowsHitTesting(false)
                }

            }
            
        }
        .edgesIgnoringSafeArea(.all)

    }
        
    func dropCircle() {
        withAnimation(
            Animation.linear(duration: speed)
        ) {
            self.isAnimating = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
