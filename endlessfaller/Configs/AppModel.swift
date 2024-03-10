//
//  AppModel.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import Foundation
import SwiftUI
import AVFoundation
import Combine
import UIKit
import NotificationCenter

let levels = 1000
let deviceHeight = UIScreen.main.bounds.height
let deviceWidth = UIScreen.main.bounds.width

class AppModel: ObservableObject {
    @Published var currentScore: Int = 0
    @Published var playedCharacter = ""
    @Published var costToContinue: Int = 1
    @Published var showContinueToPlayScreen = false
    @Published public var currentIndex: Int = -1
    @Published var score: Int = -1
    @Published var showNewBestScore = false
    @Published var highestLevelInRound = -1
    @Published var firstGamePlayed = false
    @Published var showBoinFoundAnimation = false
    @Published var freezeScrolling = false
    @Published var showWastedScreen = false
    @Published var isWasted = false
    @Published var ballSpeed: Double = 0.0
    @Published var triangleScale: CGFloat = 1.0
    @Published var triangleColor = Color.black
    @Published var showDailyBoinCollectedAnimation = false
    @Published var ballIsStrobing = false
    @Published var grabbingBoins = false
    @Published var showedNewBestScoreOnce = false
    @Published var colors: [Color] = (1...levels).map { _ in
        Color(hex: backgroundColors.randomElement()!)!
    }
    
    
    
    var gameOverDispatchTimer: DispatchSourceTimer?

    // Modifications to gameOverTimer related code
    func startGameOverTimer() {
        gameOverDispatchTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
        gameOverDispatchTimer?.schedule(deadline: .now() + 7.5)
        gameOverDispatchTimer?.setEventHandler { [weak self] in
            print("calling from wasted operations")
            self?.currentIndex = -1
        }
        gameOverDispatchTimer?.resume()
    }

    func cancelGameOverTimer() {
        gameOverDispatchTimer?.cancel()
        gameOverDispatchTimer = nil
    }
    
    
    static let sharedAppModel = AppModel()
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @ObservedObject var userPersistedData = UserPersistedData()
    @ObservedObject var audioController = AudioManager.sharedAudioManager
    @ObservedObject var gameCenter = GameCenter.shared
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    
    func dailyBoinCollected() {
        self.showDailyBoinCollectedAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.showDailyBoinCollectedAnimation = false
        }
    }
    
    func dropBall() {
        self.ballSpeed = 3
        self.BallAnimator.startTime = 0.0
        self.BallAnimator.startTimer(speed: self.ballSpeed)
    }
    
    func FlashTriangles() {
        triangleScale = 1.5 // Increase the scale factor
        triangleColor = Color.white
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.triangleScale = 1
            self.triangleColor = Color.black
        }
    }
    
    func liftBall(difficultyInput: Int) {
        /*
         level 1 is anywhere between 0.5 and 1.5 seconds
         level 1000 is anywhere between 0.1 and 0.3 seconds
         use newValue instead of score variable
         1 ->       0.5, 1.5
         1000 ->    0.05, 0.15
         */
        if userPersistedData.strategyModeEnabled {
            let m1 = -0.0004004004004004004
            let c1 = 0.5004004004004003
            let fastest = (m1 * Double(difficultyInput) + c1) * 1.8
            print("fastest: \(fastest)")
            
            let m2 = -0.0012012012012012011
            let c2 = 1.5012012012012013
            let slowest = (m2 * Double(difficultyInput) + c2) * 1.8
            print("slowest: \(slowest)")
            
            self.ballSpeed = Double.random(in: fastest...slowest)
        } else {
            self.ballSpeed = (2/(Double(difficultyInput)+12))*12 
        }
        print("ballSpeed: \(ballSpeed)")
        self.BallAnimator.pushBallUp(newBallSpeed: ballSpeed)
    }
    
    func gameOverOperations() {
        self.currentIndex = -1
        self.cancelGameOverTimer()
        self.costToContinue = 1
        audioController.musicPlayer.rate = 1
        if self.score > -1 {
            self.currentScore = self.score
        }
        self.score = -1
        audioController.musicPlayer.rate = 1
        self.showContinueToPlayScreen = false
        self.showedNewBestScoreOnce = false
        if self.currentScore > userPersistedData.bestScore {
            DispatchQueue.main.async{
                self.userPersistedData.updateBestScore(amount: self.currentScore)
            }
        }
        DispatchQueue.main.async { [self] in
            self.highestLevelInRound = -1
            self.BallAnimator.pushUp = false
            self.BallAnimator.displayLink?.invalidate()
            self.BallAnimator.endingYPosition = 90
            self.BallAnimator.ballYPosition = 90
            self.gameCenter.updateScore(currentScore: self.currentScore, ballID: userPersistedData.selectedCharacter)
        }
    }
    
    func wastedOperations() {
        self.isWasted = true
        self.freezeScrolling = true
        DispatchQueue.main.async {
            self.highestLevelInRound = -1
            self.showContinueToPlayScreen = true
            self.BallAnimator.displayLink?.invalidate()
            self.BallAnimator.pushUp = false
            self.ballIsStrobing = true
            self.highestLevelInRound = -1
        }
        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.highestLevelInRound = -1
            self.currentIndex = -2
            self.freezeScrolling = false
            self.isWasted = false
            self.ballIsStrobing = false
            self.BallAnimator.pushUp = false
            self.BallAnimator.endingYPosition = 90
            self.BallAnimator.ballYPosition = 90
        }
        self.firstGamePlayed = true
        audioController.punchSoundEffect.play()
        playedCharacter = userPersistedData.selectedCharacter
        startGameOverTimer()
    }
    
    func continuePlaying() {
        DispatchQueue.main.async{
            self.cancelGameOverTimer()
        }
        self.showContinueToPlayScreen = false
        self.costToContinue *= 2
        self.BallAnimator.endingYPosition = 90
        self.BallAnimator.ballYPosition = 90
        self.currentIndex = 0
    }
    
    @Published var hats: [Hat] = [
        Hat(hat: AnyView(NoneView()), hatID: "nohat"),
        Hat(hat: AnyView(PropellerHat()), hatID: "propellerhat"),
        Hat(hat: AnyView(ChefsHat()), hatID: "chefshat"),
        Hat(hat: AnyView(CowboyHat()), hatID: "cowboyhat"),
        Hat(hat: AnyView(SantaHat()), hatID: "santahat"),
        Hat(hat: AnyView(WizardHat()), hatID: "wizardhat"),
        Hat(hat: AnyView(GraduationCap()), hatID: "graduationcap"),
        Hat(hat: AnyView(ClownHat()), hatID: "clownhat"),
        Hat(hat: AnyView(PirateHat()), hatID: "piratehat"),
        Hat(hat: AnyView(VikingHat()), hatID: "vikinghat"),
        Hat(hat: AnyView(Fedora()), hatID: "fedora"),
        Hat(hat: AnyView(Sombrero()), hatID: "sombrero"),
        Hat(hat: AnyView(CaptainHat()), hatID: "captionhat"),
        Hat(hat: AnyView(TopHat()), hatID: "tophat"),
        Hat(hat: AnyView(Crown()), hatID: "crown")
    ]
    
    @Published var bags: [Bag] = [
        Bag(bag: AnyView(NoneView()), bagID: "nobag"),
        Bag(bag: AnyView(JetPack()), bagID: "jetpack"),
        Bag(bag: AnyView(Wings()), bagID: "wings"),
        Bag(bag: AnyView(RobotArms()), bagID: "robotarms")
    ]
        
    @Published var characters: [Character] = [
        Character(character: AnyView(WhiteBallView()), cost: "Free", characterID: "io.endlessfall.white"),
        Character(character: AnyView(BlackBallView()), cost: "Free", characterID: "io.endlessfall.black"),
        Character(character: AnyView(YinYangBallView()), cost: "Free", characterID: "io.endlessfall.orange"),
        Character(character: AnyView(FallBallLaughBall()), cost: "Free", characterID: "io.endlessfall.laugh"),
        Character(character: AnyView(EvilBall()), cost: "Free", characterID: "io.endlessfall.evil"),
        Character(character: AnyView(ShockedBall()), cost: "Free", characterID: "io.endlessfall.shocked"),
        Character(character: AnyView(BasketBall()), cost: "Free", characterID: "io.endlessfall.basketball"),
        Character(character: AnyView(SoccerBall()), cost: "Free", characterID: "io.endlessfall.soccer"),
        Character(character: AnyView(VolleyBall()), cost: "Free", characterID: "io.endlessfall.volleyball"),
        Character(character: AnyView(DiscoBall()), cost: "5", characterID: "io.endlessfall.disco"),
        Character(character: AnyView(PoolBall()), cost: "5", characterID: "io.endlessfall.poolball"),
        Character(character: AnyView(TennisBall()), cost: "5", characterID: "io.endlessfall.tennis"),
        Character(character: AnyView(ChinaView()), cost: "30", characterID: "io.endlessfall.china"),
        Character(character: AnyView(AmericaView()), cost: "30", characterID: "io.endlessfall.america"),
        Character(character: AnyView(IndiaView()), cost: "30", characterID: "io.endlessfall.india"),
        Character(character: AnyView(JapanView()), cost: "30", characterID: "io.endlessfall.japan"),
        Character(character: AnyView(UkView()), cost: "30", characterID: "io.endlessfall.uk"),
        Character(character: AnyView(GermanyView()), cost: "30", characterID: "io.endlessfall.germany"),
        Character(character: AnyView(FranceView()), cost: "30", characterID: "io.endlessfall.france"),
        Character(character: AnyView(CanadaView()), cost: "30", characterID: "io.endlessfall.canada"),
        Character(character: AnyView(BrazilView()), cost: "30", characterID: "io.endlessfall.brazil"),
        Character(character: AnyView(ParaguayView()), cost: "30", characterID: "io.endlessfall.paraguay"),
        Character(character: AnyView(ColombiaView()), cost: "30", characterID: "io.endlessfall.colombia"),
        Character(character: AnyView(SouthKoreaView()), cost: "30", characterID: "io.endlessfall.southkorea"),
        Character(character: AnyView(MexicoView()), cost: "30", characterID: "io.endlessfall.mexico"),
        Character(character: AnyView(PortugalView()), cost: "30", characterID: "io.endlessfall.portugal"),
        Character(character: AnyView(SpainView()), cost: "30", characterID: "io.endlessfall.spain"),
        Character(character: AnyView(SaudiArabiaView()), cost: "30", characterID: "io.endlessfall.saudiarabia"),
        Character(character: AnyView(UaeView()), cost: "30", characterID: "io.endlessfall.uae"),
        Character(character: AnyView(QatarView()), cost: "30", characterID: "io.endlessfall.qatar"),
        Character(character: AnyView(EthiopiaView()), cost: "30", characterID: "io.endlessfall.ethiopia"),
        Character(character: AnyView(NigeriaView()), cost: "30", characterID: "io.endlessfall.nigeria"),
        Character(character: AnyView(SouthAfricaView()), cost: "30", characterID: "io.endlessfall.southafrica"),
        Character(character: AnyView(RussiaView()), cost: "30", characterID: "io.endlessfall.russia"),
        Character(character: AnyView(BelarusView()), cost: "30", characterID: "io.endlessfall.belarus"),
        Character(character: AnyView(PolandView()), cost: "30", characterID: "io.endlessfall.poland"),
        Character(character: AnyView(UkraineView()), cost: "30", characterID: "io.endlessfall.ukraine"),
        Character(character: AnyView(FinlandView()), cost: "30", characterID: "io.endlessfall.finland"),
        Character(character: AnyView(SwedenView()), cost: "30", characterID: "io.endlessfall.sweden"),
        Character(character: AnyView(NorwayView()), cost: "30", characterID: "io.endlessfall.norway"),
        Character(character: AnyView(DenmarkView()), cost: "30", characterID: "io.endlessfall.denmark"),
        Character(character: AnyView(EstoniaView()), cost: "30", characterID: "io.endlessfall.estonia"),
        Character(character: AnyView(ItalyView()), cost: "30", characterID: "io.endlessfall.italy"),
        Character(character: AnyView(GreeceView()), cost: "30", characterID: "io.endlessfall.greece"),
        Character(character: AnyView(TurkeyView()), cost: "30", characterID: "io.endlessfall.turkey"),
        Character(character: AnyView(SomaliaView()), cost: "30", characterID: "io.endlessfall.somalia"),
        Character(character: AnyView(KenyaView()), cost: "30", characterID: "io.endlessfall.kenya"),
        Character(character: AnyView(TanzaniaView()), cost: "30", characterID: "io.endlessfall.tanzania"),
        Character(character: AnyView(ThailandView()), cost: "30", characterID: "io.endlessfall.thailand"),
        Character(character: AnyView(VietnamView()), cost: "30", characterID: "io.endlessfall.vietnam"),
        Character(character: AnyView(MalaysiaView()), cost: "30", characterID: "io.endlessfall.malaysia"),
        Character(character: AnyView(ChileView()), cost: "30", characterID: "io.endlessfall.chile"),
        Character(character: AnyView(ArgentinaView()), cost: "30", characterID: "io.endlessfall.argentina"),
        Character(character: AnyView(PeruView()), cost: "30", characterID: "io.endlessfall.peru"),
        Character(character: AnyView(PakistanView()), cost: "30", characterID: "io.endlessfall.pakistan"),
        Character(character: AnyView(BangladeshView()), cost: "30", characterID: "io.endlessfall.bangladesh"),
        Character(character: AnyView(IndonesiaView()), cost: "30", characterID: "io.endlessfall.indonesia"),
        Character(character: AnyView(EgyptView()), cost: "30", characterID: "io.endlessfall.egypt"),
        Character(character: AnyView(PalestineView()), cost: "30", characterID: "io.endlessfall.palestine"),
        Character(character: AnyView(MoroccoView()), cost: "30", characterID: "io.endlessfall.morocco"),
        Character(character: AnyView(IranView()), cost: "30", characterID: "io.endlessfall.iran"),
        Character(character: AnyView(ArmeniaView()), cost: "30", characterID: "io.endlessfall.armenia"),
        Character(character: AnyView(AfghanistanView()), cost: "30", characterID: "io.endlessfall.afghanistan"),
        Character(character: AnyView(UnicornView()), cost: "50", characterID: "io.endlessfall.unicorn"),
        Character(character: AnyView(EarthBallView()), cost: "50", characterID: "io.endlessfall.earth"),
        Character(character: AnyView(BeachBallView()), cost: "50", characterID: "io.endlessfall.beachball"),
        Character(character: AnyView(JoeRoganView()), cost: "69", characterID: "io.endlessfall.joerogan"),
        Character(character: AnyView(DjkhaledView()), cost: "69", characterID: "io.endlessfall.djkhaled"),
        Character(character: AnyView(ObamaView()), cost: "69", characterID: "io.endlessfall.obama"),
        Character(character: AnyView(AlbertView()), cost: "69", characterID: "io.endlessfall.albert"),
        Character(character: AnyView(MonkeyView()), cost: "69", characterID: "io.endlessfall.monkey"),
        Character(character: AnyView(IceSpiceView()), cost: "69", characterID: "io.endlessfall.icespice"),
        Character(character: AnyView(KaiView()), cost: "69", characterID: "io.endlessfall.kai"),
        Character(character: AnyView(RickView()), cost: "69", characterID: "io.endlessfall.rick"),
        Character(character: AnyView(MortyView()), cost: "69", characterID: "io.endlessfall.morty"),
        Character(character: AnyView(YeatView()), cost: "100", characterID: "io.endlessfall.yeat"),
        Character(character: AnyView(OnepieceView()), cost: "100", characterID: "io.endlessfall.onepiece"),
        Character(character: AnyView(AllmightView()), cost: "100", characterID: "io.endlessfall.allmight"),
        Character(character: AnyView(PearlBallView()), cost: "1000", characterID: "io.endlessfall.pearl"),
        Character(character: AnyView(GoldBallView()), cost: "4000", characterID: "io.endlessfall.gold"),
        Character(character: AnyView(DiamondBallView()), cost: "10000", characterID: "io.endlessfall.diamond")
    ]
    
    func startSharing() {
        Task {
            do {
                _ = try await SharePlayActivity().activate()
            } catch {
                print("Failed to activate SharePlay activity: \(error)")
            }
        }
    }
}

struct Character: Hashable {
    let character: AnyView // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let cost: String
    let characterID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(characterID)
    }

    static func ==(lhs: Character, rhs: Character) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.characterID == rhs.characterID
    }
}

struct Hat: Hashable {
    let hat: AnyView // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let hatID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(hatID)
    }

    static func ==(lhs: Hat, rhs: Hat) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.hatID == rhs.hatID
    }
}

struct Bag: Hashable {
    let bag: AnyView // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let bagID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(bagID)
    }

    static func ==(lhs: Bag, rhs: Bag) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.bagID == rhs.bagID
    }
}

struct BlinkViewModifier: ViewModifier {

    let duration: Double
    @State private var blinking: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(blinking ? 0.1 : 1)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever()) {
                    blinking = true
                }
            }
    }
}

struct FlashViewModifier: ViewModifier {

    let duration: Double
    @State private var flash: Bool = false

    func body(content: Content) -> some View {
        content
            .opacity(flash ? 0.3 : 1)
            .onAppear {
                withAnimation(.linear(duration: duration).repeatForever()) {
                    flash = true
                }
            }
    }
}



extension View {
    func strobing(duration: Double = 0.125 ) -> some View {
        modifier(BlinkViewModifier(duration: duration))
    }
    func flashing(duration: Double = 0.25) -> some View {
        modifier(FlashViewModifier(duration: duration))
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

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}

struct ButtonPress: ViewModifier {
    var onPress: () -> Void
    var onRelease: () -> Void
    
    func body(content: Content) -> some View {
        content
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged({ _ in
                        onPress()
                    })
                    .onEnded({ _ in
                        onRelease()
                    })
            )
    }
}

//  Written by SerialCoder.dev
extension View {
    func pressEvents(onPress: @escaping (() -> Void), onRelease: @escaping (() -> Void)) -> some View {
        modifier(ButtonPress(onPress: {
            onPress()
        }, onRelease: {
            onRelease()
        }))
    }
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX - width, y: rect.minY - width, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
    }
}

extension View {
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
}

struct RoundedAndShadowButtonStyle:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle {
    static var roundedAndShadow:RoundedAndShadowButtonStyle {
        RoundedAndShadowButtonStyle()
    }
}

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

@available(iOS 14.0, *)
public struct VTabView<Content, SelectionValue>: View where Content: View, SelectionValue: Hashable {
    
    private var selection: Binding<SelectionValue>?
    
    private var indexPosition: IndexPosition
    
    private var content: () -> Content
    
    /// Creates an instance that selects from content associated with
    /// `Selection` values.
    public init(selection: Binding<SelectionValue>?, indexPosition: IndexPosition = .leading, @ViewBuilder content: @escaping () -> Content) {
        self.selection = selection
        self.indexPosition = indexPosition
        self.content = content
    }
    
    private var flippingAngle: Angle {
        switch indexPosition {
        case .leading:
            return .degrees(0)
        case .trailing:
            return .degrees(180)
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            TabView(selection: selection) {
                Group {
                    content()
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
                .rotationEffect(.degrees(-90))
                .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
            }
            .frame(width: proxy.size.height, height: proxy.size.width)
            .rotation3DEffect(flippingAngle, axis: (x: 1, y: 0, z: 0))
            .rotationEffect(.degrees(90), anchor: .topLeading)
            .offset(x: proxy.size.width)
        }
    }
    
    public enum IndexPosition {
        case leading
        case trailing
    }
}

@available(iOS 14.0, *)
extension VTabView where SelectionValue == Int {
    
    public init(indexPosition: IndexPosition = .leading, @ViewBuilder content: @escaping () -> Content) {
        self.selection = nil
        self.indexPosition = indexPosition
        self.content = content
    }
}

extension NSDate {
    var formatted: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return  formatter.string(from: self as Date)
    }
}

class NotificationManager: ObservableObject {
    
    // Define arrays of titles and bodies
    let titles = [
        "We miss you 🫶",
        "Hey there! 👋",
        "You're missed!",
        "Hello again! ✨",
        "Guess who's back? 🌟",
        "Your world awaits 🌍",
        "Adventure time! 🚀",
        "Ready for a challenge? 🎯",
        "Let's make today special! 🎉",
        "Unseen wonders await! 🌈"
    ]
    
    // Updated bodies to mention "boins" in each message
    let bodies = [
        "Come collect your daily boins bonus!",
        "Your adventure for boins awaits. Dive in!",
        "A surprise boin is waiting for you 🎁",
        "It's time for your daily boin!",
        "Unlock your daily boin reward now!",
        "Embark on a new quest today for more boins!",
        "Special rewards in boins for special players like you! 🏆",
        "Your favorite game misses you. Return for a boins surprise! ✨",
        "Epic boins adventures await your return!",
        "Your journey for boins continues today. Don't miss out! 🌟"
    ]
    
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()

        // Randomly select a title and body
        let randomTitleIndex = Int.random(in: 0..<titles.count)
        let randomBodyIndex = Int.random(in: 0..<bodies.count)
        
        let content = UNMutableNotificationContent()
        content.title = titles[randomTitleIndex]
        content.body = bodies[randomBodyIndex]
        content.categoryIdentifier = "alarm"
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "BoingNotification.caf"))

        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.removeAllPendingNotificationRequests()
        center.add(request)
    }
    
}

/// An animatable modifier that is used for observing animations for a given animatable value.
struct AnimationCompletionObserverModifier<Value>: AnimatableModifier where Value: VectorArithmetic {

    /// While animating, SwiftUI changes the old input value to the new target value using this property. This value is set to the old value until the animation completes.
    var animatableData: Value {
        didSet {
            notifyCompletionIfFinished()
        }
    }

    /// The target value for which we're observing. This value is directly set once the animation starts. During animation, `animatableData` will hold the oldValue and is only updated to the target value once the animation completes.
    private var targetValue: Value

    /// The completion callback which is called once the animation completes.
    private var completion: () -> Void

    init(observedValue: Value, completion: @escaping () -> Void) {
        self.completion = completion
        self.animatableData = observedValue
        targetValue = observedValue
    }

    /// Verifies whether the current animation is finished and calls the completion callback if true.
    private func notifyCompletionIfFinished() {
        guard animatableData == targetValue else { return }

        /// Dispatching is needed to take the next runloop for the completion callback.
        /// This prevents errors like "Modifying state during view update, this will cause undefined behavior."
        DispatchQueue.main.async {
            self.completion()
        }
    }

    func body(content: Content) -> some View {
        /// We're not really modifying the view so we can directly return the original input value.
        return content
    }
}

extension View {

    /// Calls the completion handler whenever an animation on the given value completes.
    /// - Parameters:
    ///   - value: The value to observe for animations.
    ///   - completion: The completion callback to call once the animation completes.
    /// - Returns: A modified `View` instance with the observer attached.
    func onAnimationCompleted<Value: VectorArithmetic>(for value: Value, completion: @escaping () -> Void) -> ModifiedContent<Self, AnimationCompletionObserverModifier<Value>> {
        return modifier(AnimationCompletionObserverModifier(observedValue: value, completion: completion))
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

public extension UIDevice {

    static let modelName: String = {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        func mapToDevice(identifier: String) -> String { // swiftlint:disable:this cyclomatic_complexity
            #if os(iOS)
            switch identifier {
            case "iPod5,1":                                       return "iPod touch (5th generation)"
            case "iPod7,1":                                       return "iPod touch (6th generation)"
            case "iPod9,1":                                       return "iPod touch (7th generation)"
            case "iPhone3,1", "iPhone3,2", "iPhone3,3":           return "iPhone 4"
            case "iPhone4,1":                                     return "iPhone 4s"
            case "iPhone5,1", "iPhone5,2":                        return "iPhone 5"
            case "iPhone5,3", "iPhone5,4":                        return "iPhone 5c"
            case "iPhone6,1", "iPhone6,2":                        return "iPhone 5s"
            case "iPhone7,2":                                     return "iPhone 6"
            case "iPhone7,1":                                     return "iPhone 6 Plus"
            case "iPhone8,1":                                     return "iPhone 6s"
            case "iPhone8,2":                                     return "iPhone 6s Plus"
            case "iPhone9,1", "iPhone9,3":                        return "iPhone 7"
            case "iPhone9,2", "iPhone9,4":                        return "iPhone 7 Plus"
            case "iPhone10,1", "iPhone10,4":                      return "iPhone 8"
            case "iPhone10,2", "iPhone10,5":                      return "iPhone 8 Plus"
            case "iPhone10,3", "iPhone10,6":                      return "iPhone X"
            case "iPhone11,2":                                    return "iPhone XS"
            case "iPhone11,4", "iPhone11,6":                      return "iPhone XS Max"
            case "iPhone11,8":                                    return "iPhone XR"
            case "iPhone12,1":                                    return "iPhone 11"
            case "iPhone12,3":                                    return "iPhone 11 Pro"
            case "iPhone12,5":                                    return "iPhone 11 Pro Max"
            case "iPhone13,1":                                    return "iPhone 12 mini"
            case "iPhone13,2":                                    return "iPhone 12"
            case "iPhone13,3":                                    return "iPhone 12 Pro"
            case "iPhone13,4":                                    return "iPhone 12 Pro Max"
            case "iPhone14,4":                                    return "iPhone 13 mini"
            case "iPhone14,5":                                    return "iPhone 13"
            case "iPhone14,2":                                    return "iPhone 13 Pro"
            case "iPhone14,3":                                    return "iPhone 13 Pro Max"
            case "iPhone14,7":                                    return "iPhone 14"
            case "iPhone14,8":                                    return "iPhone 14 Plus"
            case "iPhone15,2":                                    return "iPhone 14 Pro"
            case "iPhone15,3":                                    return "iPhone 14 Pro Max"
            case "iPhone8,4":                                     return "iPhone SE"
            case "iPhone12,8":                                    return "iPhone SE (2nd generation)"
            case "iPhone14,6":                                    return "iPhone SE (3rd generation)"
            case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":      return "iPad 2"
            case "iPad3,1", "iPad3,2", "iPad3,3":                 return "iPad (3rd generation)"
            case "iPad3,4", "iPad3,5", "iPad3,6":                 return "iPad (4th generation)"
            case "iPad6,11", "iPad6,12":                          return "iPad (5th generation)"
            case "iPad7,5", "iPad7,6":                            return "iPad (6th generation)"
            case "iPad7,11", "iPad7,12":                          return "iPad (7th generation)"
            case "iPad11,6", "iPad11,7":                          return "iPad (8th generation)"
            case "iPad12,1", "iPad12,2":                          return "iPad (9th generation)"
            case "iPad13,18", "iPad13,19":                        return "iPad (10th generation)"
            case "iPad4,1", "iPad4,2", "iPad4,3":                 return "iPad Air"
            case "iPad5,3", "iPad5,4":                            return "iPad Air 2"
            case "iPad11,3", "iPad11,4":                          return "iPad Air (3rd generation)"
            case "iPad13,1", "iPad13,2":                          return "iPad Air (4th generation)"
            case "iPad13,16", "iPad13,17":                        return "iPad Air (5th generation)"
            case "iPad2,5", "iPad2,6", "iPad2,7":                 return "iPad mini"
            case "iPad4,4", "iPad4,5", "iPad4,6":                 return "iPad mini 2"
            case "iPad4,7", "iPad4,8", "iPad4,9":                 return "iPad mini 3"
            case "iPad5,1", "iPad5,2":                            return "iPad mini 4"
            case "iPad11,1", "iPad11,2":                          return "iPad mini (5th generation)"
            case "iPad14,1", "iPad14,2":                          return "iPad mini (6th generation)"
            case "iPad6,3", "iPad6,4":                            return "iPad Pro (9.7-inch)"
            case "iPad7,3", "iPad7,4":                            return "iPad Pro (10.5-inch)"
            case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":      return "iPad Pro (11-inch) (1st generation)"
            case "iPad8,9", "iPad8,10":                           return "iPad Pro (11-inch) (2nd generation)"
            case "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7":  return "iPad Pro (11-inch) (3rd generation)"
            case "iPad14,3", "iPad14,4":                          return "iPad Pro (11-inch) (4th generation)"
            case "iPad6,7", "iPad6,8":                            return "iPad Pro (12.9-inch) (1st generation)"
            case "iPad7,1", "iPad7,2":                            return "iPad Pro (12.9-inch) (2nd generation)"
            case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":      return "iPad Pro (12.9-inch) (3rd generation)"
            case "iPad8,11", "iPad8,12":                          return "iPad Pro (12.9-inch) (4th generation)"
            case "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11":return "iPad Pro (12.9-inch) (5th generation)"
            case "iPad14,5", "iPad14,6":                          return "iPad Pro (12.9-inch) (6th generation)"
            case "AppleTV5,3":                                    return "Apple TV"
            case "AppleTV6,2":                                    return "Apple TV 4K"
            case "AudioAccessory1,1":                             return "HomePod"
            case "AudioAccessory5,1":                             return "HomePod mini"
            case "i386", "x86_64", "arm64":                       return "\(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "iOS"))"
            default:                                              return identifier
            }
            #elseif os(tvOS)
            switch identifier {
            case "AppleTV5,3": return "Apple TV 4"
            case "AppleTV6,2": return "Apple TV 4K"
            case "i386", "x86_64": return "Simulator \(mapToDevice(identifier: ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] ?? "tvOS"))"
            default: return identifier
            }
            #endif
        }

        return mapToDevice(identifier: identifier)
    }()
    
    static let isOldDevice: Bool = {
            let oldDeviceNames = [
                "iPod touch (5th generation)",
                "iPod touch (6th generation)",
                "iPod touch (7th generation)",
                "iPhone 4",
                "iPhone 4s",
                "iPhone 5",
                "iPhone 5c",
                "iPhone 5s",
                "iPhone 6",
                "iPhone 6 Plus",
                "iPhone 6s",
                "iPhone 6s Plus",
                "iPhone 7",
                "iPhone 7 Plus",
                "iPhone 8",
                "iPhone 8 Plus",
                "iPhone SE", // Assuming this is the 1st generation iPhone SE
                // Add other older models as needed
            ]
        return oldDeviceNames.contains(modelName)
        }()
}

extension View {
    func flipped(_ axis: Axis = .horizontal, anchor: UnitPoint = .center) -> some View {
        switch axis {
        case .horizontal:
            return scaleEffect(CGSize(width: -1, height: 1), anchor: anchor)
        case .vertical:
            return scaleEffect(CGSize(width: 1, height: -1), anchor: anchor)
        }
    }
}

struct RandomGradientView: View {
    var gradient: LinearGradient {
        let colors = backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }
        let startPoint = UnitPoint.random
        let endPoint = UnitPoint.random
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    var body: some View {
        Rectangle()
            .fill(gradient)
            .edgesIgnoringSafeArea(.all)
    }
}

extension Array {
    func randomElement(randomCount: Int) -> [Element] {
        return (0..<2).compactMap { _ in self.randomElement() }
    }
}

extension UnitPoint {
    static var random: UnitPoint {
        return UnitPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
    }
}

extension UIDevice {
    
    // Get this value after sceneDidBecomeActive
    var hasDynamicIsland: Bool {
        // 1. dynamicIsland only support iPhone
        guard userInterfaceIdiom == .phone else {
            return false
        }
               
        // 2. Get key window, working after sceneDidBecomeActive
        guard let window = (UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }.flatMap { $0.windows }.first { $0.isKeyWindow}) else {
            print("Do not found key window")
            return false
        }
       
        // 3.It works properly when the device orientation is portrait
        return window.safeAreaInsets.top >= 51
    }
}
