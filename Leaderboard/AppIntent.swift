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
    @Parameter(title: "Podium Type", default: .allTime)
    var podiumType: PodiumType
}

enum PodiumType: String, AppEnum {
    case allTime = "All Time"
    case todays = "Today's"

    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        "Podium Type"
    }

    static var caseDisplayRepresentations: [PodiumType: DisplayRepresentation] {
        [
            .allTime: "All Time Podium",
            .todays: "Today's Podium"
        ]
    }
}
