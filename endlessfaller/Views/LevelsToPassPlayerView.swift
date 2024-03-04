//
//  LevelsToPassPlayerView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/3/24.
//

import SwiftUI
import GameKit

struct LevelsToPassPlayerView: View {
    @ObservedObject var gameCenter = GameCenter()
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var nextPlayer = Player(name: "", score: 0, ballID: 0, currentPlayer: GKLocalPlayer.local, rank: 0)
    var body: some View {
        VStack{
            HStack{
                Spacer()
                if !gameCenter.todaysPlayersList.isEmpty && gameCenter.todaysPlayersList.last?.currentPlayer != GKLocalPlayer.local {
                                        
                    VStack{
                        Text("\(nextPlayer.score - appModel.score) to pass")
                            .bold()
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding([.top])
                        if let character = appModel.characters.first(where: {$0.characterID.hash == nextPlayer.ballID}) {
                            AnyView(character.character)
                        } else {
                            Image(systemName: "questionmark.circle")
                                .font(.system(size: 40))
                        }
                        Text(nextPlayer.name)
                            .bold()
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding([.horizontal, .bottom])
                    }
                    .background(Color.primary.opacity(0.1))
                    .cornerRadius(21)
                    .frame(maxWidth: 120)
                    .padding()
                    .padding(.top, 36)
                    .onAppear{
                        if let playerPosition = gameCenter.todaysPlayersList.firstIndex(where: {$0.currentPlayer == GKLocalPlayer.local}) {
                            self.nextPlayer = gameCenter.todaysPlayersList[playerPosition + 1]
                        } else {
                            self.nextPlayer = gameCenter.todaysPlayersList[0]
                        }
                    }
                    
                }
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LevelsToPassPlayerView()
}
