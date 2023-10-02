//
//  GameCenter.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/16/23.
//

import Foundation
import GameKit
import SwiftUI
import CoreMotion

class GameCenter: ObservableObject {
    
    static let shared = GameCenter()
    @Published var playersList: [Player] = []
    init() {
        //leaderboardScores = []
        playersList = []
        //loadScores()
        Task{
            await loadLeaderboard()
        }
    }
    
    // API
    
    // status of Game Center
    
    private(set) var isGameCenterEnabled: Bool = false
    
    // try to authenticate local player (takes presenting VC for presenting Game Center VC if it's necessary)
    func authenticateLocalPlayer(presentingVC: UIViewController) {
        // authentification method
        localPlayer.authenticateHandler = { [weak self] (gameCenterViewController, error) -> Void in
            // check if there are not error
            if error != nil {
                print(error!)
            } else if gameCenterViewController != nil {
                // 1. Show login if player is not logged in
                print("Show login")
                presentingVC.present(gameCenterViewController!, animated: true, completion: nil)
            } else if (self?.localPlayer.isAuthenticated ?? false) {
                // 2. Player is already authenticated & logged in, load game center
                self?.isGameCenterEnabled = true
            } else {
                // 3. Game center is not enabled on the users device
                self?.isGameCenterEnabled = false
                print("Local player could not be authenticated!")
            }
        }
    }
    
    // method for loading scores from leaderboard
    
    func loadScores() {
        print("loadScores called")
        // fetch leaderboard from Game Center
        fetchLeaderboard { [weak self] in
            if let localLeaderboard = self?.leaderboard {
                localLeaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSMakeRange(0, 30)) { (localPlayerEntry, entries, entryCount, error) in
                    if error != nil {
                        print(error!)
                    } else if entries != nil {
                        // assemble leaderboard info
                        var leaderBoardInfo: [Player] = []
                        for score in entries! {
                            let name = score.player.displayName
                            let userScore = score.score
                            let myBallIndex = score.context
                            let player = score.player
//                            if let userballID = score.player.alias {
                            leaderBoardInfo.append(Player(name: name, score: userScore, ballID: myBallIndex, currentPlayer: player, rank: score.rank))
//                            }
                        }
                        self?.playersList = leaderBoardInfo
                        // call finished method
                    }
                }
            }
        }
    }
    
    // update local player score
    
    func updateScore(newScore: Int, ballID: Int) {
        // push score to Game Center
        let leaderboard = GKLeaderboard()
        Task{
            try await GKLeaderboard.submitScore(newScore, context: ballID, player: GKLocalPlayer.local, leaderboardIDs: [self.leaderboardID]) { error in
                
                if let error = error {
                    print("Error submitting score: \(error)")
                } else {
                    print("Score submitted successfully")
                }
            }
        }

    }
    
    // local player
    
    private var localPlayer = GKLocalPlayer.local
    
    // leaderboard ID from iTunes Connect
    
    let leaderboardID = "grp.fallball.leaderboard"
    
    //@Published var leaderboardScores: [PlayerScore] = []
 
    private var leaderboard: GKLeaderboard?
    
    // fetching leaderboard method
    
    private func fetchLeaderboard(finished: @escaping () -> ()) {
        print("fetchLeaderboard called")
        // check if local player authentificated or not
        if localPlayer.isAuthenticated {
            GKLeaderboard.loadLeaderboards(IDs: [self.leaderboardID]) { [weak self] (leaderboards, error) in
                // check for errors
                if error != nil {
                    print("Fetching leaderboard -- \(error!)")
                } else {
                    print("leaderboard fetched")
                    // if leaderboard exists
                    if leaderboards != nil {
                        for leaderboard in leaderboards! {
                            print("leaderboard:")
                            print(leaderboard)
                            // find leaderboard with given ID (if there are multiple leaderboards)
                            if leaderboard.baseLeaderboardID == self?.leaderboardID {
                                self?.leaderboard = leaderboard
                                finished()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func loadLeaderboard() async {
        playersList.removeAll()
        print("loadLeaderboard called")
        do {
            let leaderboards = try await GKLeaderboard.loadLeaderboards()
            print("leaderboards from game center class:")
            print(leaderboards)
            if let leaderboard = leaderboards.first(where: { $0.baseLeaderboardID == self.leaderboardID }) {
                print("let leaderboard if statement is true")
                let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...5))
                
                if allPlayers.1.count > 0 {
                    for leaderboardEntry in allPlayers.1 {
                        do {
                            let image = try await leaderboardEntry.player.loadPhoto(for: .small)
                            playersList.append(Player(name: leaderboardEntry.player.displayName, score: leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                        } catch {
                            print("Error loading player photo: \(error)")
                        }
                    }
                    
                    playersList.sort {
                        $0.score < $1.score
                    }
                }
            }
        } catch {
            print("Error loading leaderboard: \(error)")
        }
    }
}

//struct PlayerScore: Hashable {
//    let playerName: String
//    let playerScore: Int
//    let ballID: Int
//    let currentPlayer: GKPlayer
//}
