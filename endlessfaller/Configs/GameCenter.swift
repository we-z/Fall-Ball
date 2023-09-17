//
//  GameCenter.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/16/23.
//

import Foundation
import GameKit

class GameCenter: ObservableObject {
    
    static let shared = GameCenter()
    
    private init() {
        
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
    
    func loadScores(finished: @escaping ([(playerName: String, score: Int)]?)->()) {
        // fetch leaderboard from Game Center
        fetchLeaderboard { [weak self] in
            if let localLeaderboard = self?.leaderboard {
                // set player scope as .global (it's set by default) for loading all players results
                localLeaderboard.playerScope = .global
                // load scores and then call method in closure
                localLeaderboard.loadScores { [weak self] (scores, error) in
                    // check for errors
                    if error != nil {
                        print(error!)
                    } else if scores != nil {
                        // assemble leaderboard info
                        var leaderBoardInfo: [(playerName: String, score: Int)] = []
                        for score in scores! {
                            let name = score.player.alias
                            let userScore = Int(score.value)
                            //let ballID = score.player.guestIdentifier
                            leaderBoardInfo.append((playerName: name, score: userScore))
                        }
                        self?.scores = leaderBoardInfo
                        // call finished method
                        finished(self?.scores)
                    }
                }
            }
        }
    }
    
    // update local player score
    
    func updateScore(with value: Int) {
        // take score
        let score = GKScore(leaderboardIdentifier: leaderboardID)
        // set value for score
        score.value = Int64(value)
        // push score to Game Center
        GKScore.report([score]) { (error) in
            // check for errors
            if error != nil {
                print("Score updating -- \(error!)")
            }
        }
    }
    
    // local player
    
    private var localPlayer = GKLocalPlayer.local
    
    // leaderboard ID from iTunes Connect
    
    private let leaderboardID = "com.example.top"
    
    private var scores: [(playerName: String, score: Int)]?
 
    private var leaderboard: GKLeaderboard?
    
    // fetching leaderboard method
    
    private func fetchLeaderboard(finished: @escaping () -> ()) {
        // check if local player authentificated or not
        if localPlayer.isAuthenticated {
            // load leaderboard from Game Center
            GKLeaderboard.loadLeaderboards { [weak self] (leaderboards, error) in
                // check for errors
                if error != nil {
                    print("Fetching leaderboard -- \(error!)")
                } else {
                    // if leaderboard exists
                    if leaderboards != nil {
                        for leaderboard in leaderboards! {
                            // find leaderboard with given ID (if there are multiple leaderboards)
                            if leaderboard.identifier == self?.leaderboardID {
                                self?.leaderboard = leaderboard
                                finished()
                            }
                        }
                    }
                }
            }
        }
    }
}
