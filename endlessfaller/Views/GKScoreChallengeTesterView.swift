//
//  GKScoreChallengeTesterView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/20/24.
//

import SwiftUI
import GameKit

struct GKScoreChallengeTesterView: View {
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

#Preview {
    GKScoreChallengeTesterView()
}
