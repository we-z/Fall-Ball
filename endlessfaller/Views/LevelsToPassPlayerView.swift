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

    var body: some View {
        let todaysPlayersList = gameCenter.todaysPlayersList
        VStack{
            HStack{
                Spacer()
                if todaysPlayersList.count > 0 {
                    if todaysPlayersList[0].currentPlayer != GKLocalPlayer.local {
                        let nextPlayerIndex = (todaysPlayersList.firstIndex(where: {$0.currentPlayer == GKLocalPlayer.local}) ?? 0) - 1
                        VStack{
                            Text("\(todaysPlayersList[nextPlayerIndex].score - appModel.score) to pass")
                                .bold()
                                .italic()
                                .multilineTextAlignment(.center)
                                .padding([.top])
                            if let character = appModel.characters.first(where: {$0.characterID.hash == todaysPlayersList[nextPlayerIndex].ballID}) {
                                AnyView(character.character)
                            } else {
                                Image(systemName: "questionmark.circle")
                                    .font(.system(size: 40))
                            }
                            Text(todaysPlayersList[nextPlayerIndex].name)
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
                        
                        
                    }
                }
            }
            Spacer()
        }
    }
}

#Preview {
    LevelsToPassPlayerView()
}
