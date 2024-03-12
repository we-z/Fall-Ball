//
//  LevelsToPassPlayerView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/3/24.
//

import SwiftUI
import GameKit

struct LevelsToPassPlayerView: View {
    @ObservedObject var gameCenter = GameCenter.shared
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var userPersistedData = UserPersistedData()
    @State var cardXoffset = 0.0
    @State var cardYoffset = 0.0
    @State var show5boinsAnimation = false
    
    func cardPassAnimation() {
        withAnimation(.linear(duration: 0.3)) {
            cardXoffset = 100
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            cardYoffset = -150
            cardXoffset = 0
            withAnimation(.linear(duration: 0.3)) {
                cardYoffset = 0
            }
        }
    }
    
    func firstPlaceOnLeaderboardReward() {
        userPersistedData.leaderboardWonToday = true
        show5boinsAnimation = true
        
    }
    
    var body: some View {
        let todaysPlayersList = gameCenter.todaysPlayersList
        ZStack {
            VStack{
                HStack{
                    Spacer()
                    if todaysPlayersList.count > 0 {
                        if todaysPlayersList[0].currentPlayer != GKLocalPlayer.local && gameCenter.nextPlayerIndex > -1 {
                                VStack{
                                    Text("\(todaysPlayersList[gameCenter.nextPlayerIndex].score - appModel.score) to pass")
                                        .bold()
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding([.horizontal, .top])
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == todaysPlayersList[gameCenter.nextPlayerIndex].ballID}) {
                                        AnyView(character.character)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 40))
                                    }
                                    Text(todaysPlayersList[gameCenter.nextPlayerIndex].name)
                                        .bold()
                                        .italic()
                                        .multilineTextAlignment(.center)
                                        .padding([.horizontal, .bottom])
                                }
                                .background(Color.primary.opacity(0.1))
                                .cornerRadius(21)
                                .frame(width: 120)
                                .padding()
                                .padding(.top, 36)
                                .offset(x: cardXoffset, y: cardYoffset)
                                .onChange(of: appModel.score) { newScore in
                                    if newScore >= todaysPlayersList[gameCenter.nextPlayerIndex].score {
                                        if gameCenter.nextPlayerIndex > 0 {
                                            print("nextPlayerIndex should be modified")
                                            cardPassAnimation()
                                            gameCenter.nextPlayerIndex -= 1
                                        } else {
                                            firstPlaceOnLeaderboardReward()
                                            gameCenter.nextPlayerIndex = -1
                                        }
                                    }
                                }
                        }
                    }
                }
                Spacer()
            }
            if show5boinsAnimation == true {
                LeaderboardRewardView()
            }
        }
    }
}

struct LeaderboardRewardView: View {
    @ObservedObject var userPersistedData = UserPersistedData()
    @State var animationXoffset = 0.0
    @State var animationYoffset = -(deviceHeight / 1.5)
    @State var scaleSize = 1.0
    @State private var rotationAngle: Double = 0
    @State private var isAnimating = false
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    BoinsView()
                        .offset(y: -50)
                        .rotationEffect(.degrees(Double(index) / Double(5) * 360))
                }
            }
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                self.isAnimating = true
            }
            Text("#1 Place! 🏎️💨")
                .font(.largeTitle)
                .bold()
                .italic()
                .padding(45)
            
        }
        .scaleEffect(scaleSize)
        .offset(x: animationXoffset, y: animationYoffset)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                animationYoffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 2)) {
                    animationYoffset = -(deviceHeight / 1.5)
                    animationXoffset = deviceWidth / 1.5
                    scaleSize = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                userPersistedData.incrementBalance(amount: 5)
            }
        }
    }
}

#Preview {
    LevelsToPassPlayerView()
}
