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
import FirebaseAnalytics
import FirebaseAuth

class GameCenter: ObservableObject {
    
    @Published var nextPlayerIndex = -1
    @Published var todaysPlayersList = [Player]()
    @Published var allTimePlayersList = [Player]()
    @ObservedObject var notificationManager = NotificationManager()
    
    static let shared = GameCenter()
    
    func notifyPassedPlayers(newScore: Int) {
        let oldPlayerPosition = todaysPlayersList.first(where: {
            $0.currentPlayer == GKLocalPlayer.local
        })
        
        // Todays Players
        for playerEntry in todaysPlayersList {
            if playerEntry.score > oldPlayerPosition?.score ?? 0 && playerEntry.score < newScore {
                notificationManager.createPassRecord(recieverAlias: playerEntry.name)
            }
        }
        
        // All time Players
        for playerEntry in allTimePlayersList {
            if playerEntry.score > oldPlayerPosition?.score ?? 0 && playerEntry.score < newScore {
                notificationManager.createPassRecord(recieverAlias: playerEntry.name)
            }
        }
    }

    func authenticateUser(userData: UserPersistedData) {
//        print("authenticateUser called")
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                debugPrint("authHandler - ERROR: \(error!.localizedDescription)")
                return
            }
            if Referrals.isFeatureEnabled() {
                Task {
                    let credential = try? await GameCenterAuthProvider.getCredential()
                    if let credential = credential {
                        Referrals.authorize(credential: credential) { user, status in
                            debugPrint("authenticateUser - \(user)")
                            user.makeReferralLink { url in
                                userData.referralURL = url?.absoluteString ?? "none"
                            }
                            user.setDisplayName(GKLocalPlayer.local.displayName)
                        }
                    }
                }
            }
            Task {
                await self.loadLeaderboards()
            }
            self.notificationManager.registerLocal()
            
        }
    }
    
    // update local player score
    func updateScore(currentScore: Int, ballID: String) {
        Analytics.logEvent(AnalyticsEventPostScore, parameters: [
            AnalyticsParameterScore: currentScore,
            AnalyticsParameterCharacter: ballID
        ])
        
        notifyPassedPlayers(newScore: currentScore)
        
        // push score to Game Center leaderboards
        GKLeaderboard.submitScore(currentScore,
                                  context: ballID.hash,
                                  player: GKLocalPlayer.local,
                                  leaderboardIDs: [self.leaderboardID, self.allTimeLeaderboardID]) { error in
            if let error = error {
                print("Error submitting score: \(error)")
            } else {
                print("Score submitted to daily successfully")
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
    func loadLeaderboard(withIdentifier: String) async {
        GKLeaderboard.loadLeaderboards(IDs: [leaderboardIdentifier, allTimeLeaderboardID]) { leaderboards, error in
            leaderboards?[0].loadEntries(
                for: .global,
                timeScope: .allTime,
                range: NSRange(1...50),
                completionHandler: { mine, entries, count,  error in
                    debugPrint("loadEntries .allTime - \(mine.debugDescription)")
                }
            )
            
            leaderboards?[1].loadEntries(
                for: .global,
                timeScope: .today,
                range: NSRange(1...50),
                completionHandler: { mine, entries, count,  error in
                    debugPrint("loadEntries .today - \(mine.debugDescription)")
                }
            )
        }
    }
    
    func loadLeaderboards() async {
        print("loadLeaderboards called")
        
//        Task {
//            await loadLeaderboard(withIdentifier: leaderboardIdentifier)
//            await loadLeaderboard(withIdentifier: allTimeLeaderboardIdentifier)
//        }
        
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
                todaysPlayersList = todaysPlayersListTemp
                nextPlayerIndex = (todaysPlayersList.firstIndex(where: {
                    $0.currentPlayer == GKLocalPlayer.local
                }) ?? todaysPlayersList.count) - 1
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
