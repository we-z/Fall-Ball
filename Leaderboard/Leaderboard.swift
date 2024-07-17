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
        if let imageUrl = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.FallBallGroup")?.appendingPathComponent("allTimePodium.png"),
                   let imageData = try? Data(contentsOf: imageUrl),
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
        } else {
            VStack{
                Text("Loading Leaderboard...")
                    .italic()
                    .bold()
            }
        }
    }
}

struct CustomTextStrokeModifier: ViewModifier {
    var id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .black

    func body(content: Content) -> some View {
        if strokeSize > 0 {
            appliedStrokeBackground(content: content)
        } else {
            content
        }
    }

    func appliedStrokeBackground(content: Content) -> some View {
        
        content
            .background(
                Rectangle()
                    .foregroundColor(strokeColor)
                    .mask {
                        mask(content: content)
                    }
                    .padding(-10)
                    .allowsHitTesting(false)
            )
            .foregroundColor(.white)
    }

    func mask(content: Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            if let resolvedView = context.resolveSymbol(id: id) {
                context.draw(resolvedView, at: .init(x: size.width/2, y: size.height/2))
            }
        } symbols: {
            content
                .tag(id)
                .blur(radius: strokeSize)
        }
    }
}

extension View {
    func customTextStroke(color: Color = .black, width: CGFloat = 1) -> some View {
        self.modifier(CustomTextStrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct Leaderboard: Widget {
    let kind: String = "Leaderboard"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            LeaderboardEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .contentMarginsDisabled()
    }
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "😀"
        return intent
    }
    
    fileprivate static var starEyes: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        intent.favoriteEmoji = "🤩"
        return intent
    }
}

struct RandomGradientView: View {
    // Define a state for the gradient to trigger updates
    @State private var gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    // Timer to change the gradient periodically
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        Rectangle()
            .fill(gradient)
            .edgesIgnoringSafeArea(.all)
    }
    
    func randomGradient() -> LinearGradient {
        let colors = backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }
        let startPoint = UnitPoint(x: 0, y: 0)
        let endPoint = UnitPoint(x: 1, y: 1)
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}

extension Array {
    func randomElement(randomCount: Int) -> [Element] {
        return (0..<2).compactMap { _ in self.randomElement() }
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}


let backgroundColors: [String] = [
    "#FF00FF", // Neon Pink
    "#01FF70", // Bright Green
    "#00FFFF", // Cyan
    "#FF6EFF", // Hot Pink
    "#00FF00", // Lime Green
    "#FF6600", // Neon Orange
    "#33FF00", // Neon Green
    "#FF3300", // Bright Red
    "#FF0099", // Magenta
    "#66FF00", // Bright Yellow-Green
    "#FF0066", // Deep Pink
    "#99FF00", // Chartreuse
    "#FF0000", // Red
    "#00FFCC", // Aqua
    "#FF99CC", // Pinkish
    "#00CCFF", // Sky Blue
    "#FFCC00", // Gold
    "#CC00FF", // Purple
    "#FFFF00", // Yellow
    "#FF99FF", // Pale Pink
    "#0099FF", // Azure
    "#FF6600", // Orange
    "#00FF99", // Mint
    "#FF6699", // Rosy
    "#00FF66", // Spring Green
    "#CCFF00", // Lemon
    "#FF3366", // Rose
    "#00FF33", // Greenish
    "#FF33CC", // Neon Purple
    "#0099CC", // Cerulean
    "#FF0033", // Bright Red
    "#33FFCC", // Turquoise
    "#00CC99", // Peacock Blue
    "#99CC00", // Olive Green
    "#CC66FF", // Lavender
    "#FF6633", // Tangerine
    "#33CCFF", // Light Blue
    "#99FF99", // Light Mint
    "#FF3399", // Deep Rose
    "#0066FF", // Electric Blue
    "#FF9900", // Dark Orange
    "#66FF99", // Aqua Green
    "#FF33FF", // Bright Purple
    "#009966", // Teal
    "#99FF66", // Light Lime
    "#FF0099", // Deep Magenta
    "#66CC00", // Dark Lime
    "#FF66CC", // Light Magenta
    "#00FFCC", // Bright Cyan
    "#66FF33", // Lime
    "#99CCFF", // Pale Blue
    "#FF0066", // Neon Red
    "#33FF99", // Sea Green
    "#CC99FF", // Light Lavender
    "#00FF66", // Light Green
    "#33FF33", // Neon Light Green
    "#FF6633", // Dark Peach
    "#0099FF", // Light Electric Blue
    "#FFCC66", // Peach
    "#66FFCC", // Light Cyan
    "#FF0000", // Neon Red
    "#33CC99", // Dark Cyan
    "#99FF33", // Yellow Green
    "#FF33FF", // Neon Magenta
    "#009966", // Dark Turquoise
    "#99FF66", // Light Yellow Green
    "#FF0099", // Neon Deep Pink
    "#66CC00", // Darker Lime
    "#FF66CC", // Light Neon Pink
    "#00FFCC", // Neon Cyan
    "#66FF33", // Brighter Lime
    "#99CCFF", // Pale Sky Blue
    "#FF0066", // Bright Neon Pink
    "#33FF99", // Light Sea Green
    "#CC99FF", // Pale Lavender
    "#00FF66", // Neon Spring Green
    "#33FF33", // Bright Neon Light Green
    "#FF6633", // Neon Peach
    "#0099FF", // Deep Sky Blue
    "#FFCC66", // Neon Pale Peach
    "#66FFCC", // Neon Light Cyan
    "#FF0000", // Pure Red
    "#33CC99", // Dark Sea Green
    "#99FF33", // Light Neon Lime
    "#FF33FF", // Neon Violet
    "#009966", // Forest Green
    "#99FF66", // Pale Neon Lime
    "#FF0099", // Neon Rose
    "#66CC00", // Grass Green
    "#FF66CC", // Neon Pale Pink
    "#00FFCC", // Bright Turquoise
    "#66FF33", // Spring Lime
    "#99CCFF", // Daylight Blue
    "#FF0066", // Neon Fuchsia
    "#33FF99",  // Fresh Green
    "#4285F4", // Google Blue
    "#DB4437", // Google Red
    "#F4B400", // Google Yellow
    "#0F9D58", // Google Green
    "#4267B2", // Facebook Blue
    "#F40009", // Coca-Cola Red
    "#054ADA", // IBM Blue
    "#FFC72C", // McDonald's Yellow
    "#00704A", // Starbucks Green
    "#FF9900", // Amazon Orange
    "#A3AAAE", // Apple Black
    "#1DA1F2", // Twitter Blue
    "#E30022", // YouTube Red
    "#FF6900", // SoundCloud Orange
    "#00A8E1", // Skype Blue
    "#E31B23", // Netflix Red
    "#ED1C24", // Adobe Red
    "#1ed760", // Spotify Green
    "#BD081C", // Pinterest Red
    "#00AFF0", // LinkedIn Blue
    "#2BAC76", // WhatsApp Green
    "#F65314", // Microsoft Orange
    "#7B5294", // Twitch Purple
    "#FF4500", // Reddit Orange
    "#CCD6DD", // Twitter Light Blue
    "#00B2FF", // Samsung Blue
    "#F05A28", // Harley Davidson Orange
    "#4C75A3", // Ford Blue
    "#138808", // John Deere Green
    "#EB2226", // Lego Red
    "#E2231A", // Kellogg's Red
    "#FFD700" // Ferrari Yellow
]

#Preview(as: .systemLarge) {
    Leaderboard()
} timeline: {
    SimpleEntry(date: .now, configuration: .smiley)
    SimpleEntry(date: .now, configuration: .starEyes)
}
