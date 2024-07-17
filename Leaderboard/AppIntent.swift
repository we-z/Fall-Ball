//
//  AppIntent.swift
//  Leaderboard
//
//  Created by Wheezy Salem on 5/23/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("This is an example widget.")

    // An example configurable parameter.
    @Parameter(title: "All Time Podium", default: "🏆")
    var currentPodium: String
}
