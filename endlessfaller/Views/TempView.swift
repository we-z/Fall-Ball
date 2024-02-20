//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import GameKit



struct TempView: View {
    var body: some View {
        Button("Create Challenge") {
            createChallenge()
        }
    }
    
    func createChallenge() {
        
        // Create a GKScoreChallenge with the receiving player
        let playerToSend = GKLocalPlayer()
        let scoreChallenge = GKScoreChallenge()
        let playerEntry = GKLeaderboard.Entry.self
        // Set the score property
//            scoreChallenge.score!.value = 100
//            scoreChallenge.score!.leaderboardIdentifier = "fallball.leaderboard"
        
        // Issue the challenge
        scoreChallenge.score?.challengeComposeController(withMessage: "Beat Me", players: [playerToSend])

    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
