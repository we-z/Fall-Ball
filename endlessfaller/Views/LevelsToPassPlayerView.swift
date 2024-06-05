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
        appModel.show5boinsAnimation = true
        
    }
    
    var body: some View {
        let todaysPlayersList = gameCenter.todaysPlayersList
        if todaysPlayersList.count > 0 {
            if todaysPlayersList[0].currentPlayer != GKLocalPlayer.local && gameCenter.nextPlayerIndex > -1 {
                VStack{
                    Text("\(todaysPlayersList[gameCenter.nextPlayerIndex].score - appModel.score) to pass")
                        .bold()
                        .italic()
                        .customTextStroke()
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .top])
                    if let character = appModel.characters.first(where: {$0.characterID.hash == todaysPlayersList[gameCenter.nextPlayerIndex].ballID}) {
                        AnyView(character.character)
                    } else {
                        Image(systemName: "questionmark.circle")
                            .font(.system(size: 40))
                    }
                    Text(todaysPlayersList[gameCenter.nextPlayerIndex].name)
                        .multilineTextAlignment(.center)
                        .bold()
                        .italic()
                        .padding([.horizontal, .bottom])
                        .customShadow(radius: 0.1, width: 0.6)
                }
                .frame(width: 127)
                .background(Color.black.opacity(0.1))
                .cornerRadius(21)
                .padding()
                .padding(.top, 36)
                .offset(x: cardXoffset, y: cardYoffset)
                .onChange(of: appModel.score) { newScore in
                    if newScore >= todaysPlayersList[gameCenter.nextPlayerIndex].score {
                        if gameCenter.nextPlayerIndex > 0 {
                            print("nextPlayerIndex should be modified")
                            cardPassAnimation()
                        } else {
                            if !userPersistedData.leaderboardWonToday {
                                firstPlaceOnLeaderboardReward()
                            }
                        }
                        gameCenter.nextPlayerIndex -= 1
                    }
                }
            }
        }
    }
}

#Preview {
    LevelsToPassPlayerView()
}
