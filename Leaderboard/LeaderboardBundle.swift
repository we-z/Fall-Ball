//
//  LeaderboardBundle.swift
//  Leaderboard
//
//  Created by Wheezy Salem on 5/23/24.
//

import WidgetKit
import SwiftUI

@main
struct LeaderboardBundle: WidgetBundle {
    var body: some Widget {
        Leaderboard()
        LeaderboardLiveActivity()
    }
}
