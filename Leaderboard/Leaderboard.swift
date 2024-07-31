//
//  Leaderboard.swift
//  Leaderboard
//
//  Created by Wheezy Salem on 5/23/24.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
}

struct LeaderboardEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        let imageName: String = {
            switch entry.configuration.podiumType {
            case .allTime:
                return "allTimePodium.png"
            case .todays:
                return "todaysPodium.png"
            }
        }()

        if let imageUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.FallBallGroup")?.appendingPathComponent(imageName),
           let imageData = try? Data(contentsOf: imageUrl),
           let uiImage = UIImage(data: imageData) {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
        } else {
            VStack {
                Text("Sign in Game Center")
                    .italic()
                    .bold()
            }
        }
    }
}

struct Leaderboard: Widget {
    let kind: String = "Leaderboard"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LeaderboardEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([])
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var allTimePodium: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.podiumType = .allTime
        return intent
    }
    fileprivate static var todaysPodium: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.podiumType = .todays
        return intent
    }
}

#Preview(as: .systemLarge) {
    Leaderboard()
} timeline: {
    SimpleEntry(date: .now, configuration: .allTimePodium)
}
