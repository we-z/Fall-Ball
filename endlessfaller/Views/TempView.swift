//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import VTabView
import QuartzCore


struct TempView: View {
    @StateObject private var timerManager = TimerManager()
    @State var currentIndex: Int = 0
    @State var highestScoreInGame: Int = 0
    @State var colors: [Color] = (1...levels).map { _ in
        Color(red: .random(in: 0.4...1), green: .random(in: 0.4...1), blue: .random(in: 0.4...1))
    }
    
    let deviceWidth = UIScreen.main.bounds.width
    
    func dropBall() {
        timerManager.startTimer(speed: 1)
    }
    
    var body: some View {
        ZStack{
            ScrollView {
                ZStack{
                    VTabView(selection: $currentIndex){
                        ForEach(colors.indices, id: \.self) { index in
                            ZStack{
                                colors[index]
                                if index == highestScoreInGame{
                                    WhiteBallView()
                                        .position(x: deviceWidth/2, y: self.timerManager.ballYPosition)
                                        .allowsHitTesting(false)
                                }
                            }
                        }
                    }
                    .frame(
                        width: deviceWidth,
                        height: UIScreen.main.bounds.height
                    )
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .onChange(of: currentIndex) { newValue in
                        if newValue > highestScoreInGame {
                            highestScoreInGame = newValue
                        }
                        dropBall()
                    }
                    Text("\(currentIndex)")
                        .font(.largeTitle)
                        .allowsHitTesting(false)
                        .position(x:50, y: 100)
                }
            }
            .edgesIgnoringSafeArea(.all)
        }
        .environmentObject(timerManager)
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
