//
//  LeaderboardLiveActivity.swift
//  Leaderboard
//
//  Created by Wheezy Salem on 5/23/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LeaderboardAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LeaderboardLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LeaderboardAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LeaderboardAttributes {
    fileprivate static var preview: LeaderboardAttributes {
        LeaderboardAttributes(name: "World")
    }
}

extension LeaderboardAttributes.ContentState {
    fileprivate static var smiley: LeaderboardAttributes.ContentState {
        LeaderboardAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LeaderboardAttributes.ContentState {
         LeaderboardAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LeaderboardAttributes.preview) {
   LeaderboardLiveActivity()
} contentStates: {
    LeaderboardAttributes.ContentState.smiley
    LeaderboardAttributes.ContentState.starEyes
}
