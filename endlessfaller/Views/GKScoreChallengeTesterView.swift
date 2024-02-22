//
//  GKScoreChallengeTesterView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/20/24.
//

import SwiftUI
import GameKit

struct GKScoreChallengeTesterView: View {
    
//    @ObservedObject var gameCenter = GameCenter()
//    let leaderboardIdentifier = "fallball.leaderboard"
//    
//    var body: some View {
//        VStack {
//            Button("Issue Challenge") {
//                issueScoreChallenge()
//            }
//        }
//    }
//    
//    func issueScoreChallenge() {
//        
//        
//        // Create a GKScoreChallenge object
//        let scoreChallenge = GKScoreChallenge()
//        let score = GKScore()
//        score.leaderboardIdentifier = "fallball.leaderboard"
//        
//        let currentPlayer = gameCenter.todaysPlayersList.first?.currentPlayer
////        scoreChallenge.score
//        
//        // Compose a challenge view controller
//        if #available(iOS 17.0, *) {
//            let challengeController = score.challengeComposeController(
//                withMessage: "Can you beat my score?",
//                players: nil,
//                completion: { viewController, didIssue, players in
//                    if didIssue {
//                        // Challenge issued successfully
//                        print("Challenge issued successfully")
//                    } else {
//                        // Challenge issuing cancelled
//                        print("Challenge issuing cancelled")
//                    }
//                }
//            )
//            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
//                if let window = windowScene.windows.first {
//                    window.rootViewController?.present(challengeController, animated: true, completion: nil)
//                }
//            }
//        }
//    }
    
    @ObservedObject var gameCenter = GameCenter()
    let leaderboardIdentifier = "fallball.leaderboard"
    
    var body: some View {
        VStack {
            Button {
                issueScoreChallenge()
            } label: {
                Text("issue challenge")
            }
        }
        .onAppear{
            if !GKLocalPlayer.local.isAuthenticated {
                gameCenter.authenticateUser()
            }
        }
    }
    
    func issueScoreChallenge() {
        Task {
            do {
                print("Task running")
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.leaderboardIdentifier])
                print("leaderboards")
                print(leaderboards)
                if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
                    print("leaderboard")
                    print(leaderboard)
                    let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                    print("allPlayers:")
                    print(allPlayers)
                    DispatchQueue.main.async {
                        let challengeController = allPlayers.1.first!.challengeComposeController(withMessage: "BEAT IT", players: [GKLocalPlayer.local])
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            if let window = windowScene.windows.first {
                                window.rootViewController?.present(challengeController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            } catch {
                print("Error: \(error)")
                // Handle error, perhaps show an alert to the user
            }
        }
    }
}

#Preview {
    GKScoreChallengeTesterView()
}
