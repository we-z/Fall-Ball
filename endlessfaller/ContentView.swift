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
    @State var currentIndex: Int = -1
    @State var isAnimating = false
    @State var firstScreen = true
    @State var speed: Double = 2
    
    let colors: [Color] = (1...1000).map { _ in
        Color(red: .random(in: 0.2...0.9), green: .random(in: 0.2...0.9), blue: .random(in: 0.2...0.9))
    }
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    
                    VStack{
                        Text("Swipe up \nto play")
                            .multilineTextAlignment(.center)
                            .padding()
                        Image(systemName: "arrow.up")
                    }
                    .bold()
                    .font(.largeTitle)
                    .tag(-1)
                    
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack{
                            Rectangle()
                                .fill(colors[index])
                            Circle()
                                .allowsHitTesting(false)
                                .frame(width: 46)
                                .colorInvert()
                                .position(x: UIScreen.main.bounds.width/2, y: isAnimating ? 960 : -23)
                            
                        }
                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: 940
                )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .onChange(of: currentIndex) { newValue in
                    firstScreen = false
                    score = newValue
                    speed = 2.0 / ((Double(newValue) / 39) + 1)
                    self.isAnimating = false
                    dropCircle()
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
