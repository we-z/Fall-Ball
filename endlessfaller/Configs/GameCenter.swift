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
    
    @Published var nextPlayerIndex = -1
    @Published var todaysPlayersList: [Player] = []
    @Published var allTimePlayersList: [Player] = []
    @ObservedObject var notificationManager = NotificationManager()
    
    static let shared = GameCenter()
    
    // API
    
    // status of Game Center
    
    private(set) var isGameCenterEnabled: Bool = false
    
    func notifyPassedPlayers(newScore: Int) {
        let oldPlayerPosition = todaysPlayersList.first(where: {$0.currentPlayer == GKLocalPlayer.local})
        
        // Todays Players
        for playerEntry in todaysPlayersList {
            if playerEntry.score > oldPlayerPosition?.score ?? 0 && playerEntry.score < newScore {
                self.notificationManager.createPassRecord(recieverAlias: playerEntry.name)
            }
        }
        
        // All time Players
        for playerEntry in allTimePlayersList {
            if playerEntry.score > oldPlayerPosition?.score ?? 0 && playerEntry.score < newScore {
                self.notificationManager.createPassRecord(recieverAlias: playerEntry.name)
            }
        }
    }

    func authenticateUser() {
        print("authenticateUser called")
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            Task{
                await self.loadLeaderboard()
            }
            self.notificationManager.registerLocal()
        }
    }
    
    // update local player score
    
    func updateScore(currentScore: Int, ballID: String) {
        notifyPassedPlayers(newScore: currentScore)
        // push score to Game Center
        Task{
            GKLeaderboard.submitScore(currentScore, context: ballID.hash, player: GKLocalPlayer.local, leaderboardIDs: [self.leaderboardID, self.allTimeLeaderboardID]) { error in
                
                if let error = error {
                    print("Error submitting score: \(error)")
                } else {
                    print("Score submitted to daily successfully")
                }
            }
        }
    }
    
    // local player
    
    private var localPlayer = GKLocalPlayer.local
    
    // leaderboard ID from iTunes Connect
    
    let leaderboardID = "grp.fallball.leaderboard"
    let allTimeLeaderboardID = "grp.AllTimeLeaderboard"
    
 
    private var leaderboard: GKLeaderboard?
    let leaderboardIdentifier = "fallball.leaderboard"
    let allTimeLeaderboardIdentifier = "grp.AllTimeLeaderboard"
    
    // fetching leaderboard method
    
    func loadLeaderboard() async {
        print("loadLeaderboard called")
            Task{
                var todaysPlayersListTemp : [Player] = []
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.leaderboardIdentifier])
                if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
                    let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                    if allPlayers.1.count > 0 {
                        allPlayers.1.forEach { leaderboardEntry in
                            todaysPlayersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                            todaysPlayersListTemp.sort{
                                $0.score > $1.score
                            }
                        }
                    }
                }
                if todaysPlayersListTemp.count > 0 {
                    self.todaysPlayersList = todaysPlayersListTemp
                    nextPlayerIndex = (todaysPlayersList.firstIndex(where: {$0.currentPlayer == GKLocalPlayer.local}) ?? todaysPlayersList.count) - 1
                }
                
            }
            Task{
                var allTimePlayersListTemp : [Player] = []
                let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.allTimeLeaderboardIdentifier])
                if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.allTimeLeaderboardIdentifier }).first {
                    let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                    if allPlayers.1.count > 0 {
                        allPlayers.1.forEach { leaderboardEntry in
                            allTimePlayersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                            allTimePlayersListTemp.sort{
                                $0.score > $1.score
                            }
                        }
                    }
                }
                self.allTimePlayersList = allTimePlayersListTemp
            }
    }
}
