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
        userPersistedData.incrementBalance(amount: 5)
    }
    
    var body: some View {
        let todaysPlayersList = gameCenter.todaysPlayersList
        ZStack {
            VStack{
                HStack{
                    Spacer()
                    if todaysPlayersList.count > 0 {
                        if todaysPlayersList[0].currentPlayer != GKLocalPlayer.local {
                            if userPersistedData.leaderboardWonToday == false {
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
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            //if show5boinsAnimation == true {
                LeaderboardRewardView()
            //}
        }
    }
}

struct LeaderboardRewardView: View {
    var body: some View {
        Circle()
    }
}

#Preview {
    LevelsToPassPlayerView()
}
