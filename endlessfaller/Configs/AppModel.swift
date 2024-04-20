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
import FirebaseAnalytics

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
    @Published var show5boinsAnimation = false
    @Published var paused = false
    @Published var pausedYposition = 0.0
    @Published var colors: [Color] = (1...levels).map { _ in
        Color(hex: backgroundColors.randomElement()!)!
    }
    
    func pauseGame() {
        BallAnimator.displayLink?.invalidate()
        freezeScrolling = true
        paused = true
        pausedYposition = BallAnimator.ballYPosition
    }
    
    func continueGame() {
        freezeScrolling = false
        BallAnimator.endingYPosition = pausedYposition
        BallAnimator.startTimer(speed: BallAnimator.ballSpeed)
        paused = false
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
            if userPersistedData.selectedBag == "jetpack" {
                self.ballSpeed = (2/(Double(difficultyInput)+90))*90
            } else {
                self.ballSpeed = (2/(Double(difficultyInput)+60))*60
            }
        }
        print("ballSpeed: \(ballSpeed)")
        self.BallAnimator.pushBallUp(newBallSpeed: ballSpeed)
    }
    
    func gameOverOperations() {
        Analytics.logEvent(AnalyticsEventLevelEnd, parameters: [AnalyticsParameterScore: currentScore])
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
            Analytics.logEvent("level_continue", parameters: [AnalyticsParameterPrice: self.costToContinue])
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
        Character(name: "white ball", character: AnyView(WhiteBallView()), cost: "Free", characterID: "io.endlessfall.white"),
        Character(name: "black ball", character: AnyView(BlackBallView()), cost: "Free", characterID: "io.endlessfall.black"),
        Character(name: "yinyang ball", character: AnyView(YinYangBallView()), cost: "Free", characterID: "io.endlessfall.orange"),
        Character(name: "happy ball", character: AnyView(FallBallLaughBall()), cost: "Free", characterID: "io.endlessfall.laugh"),
        Character(name: "evil ball", character: AnyView(EvilBall()), cost: "Free", characterID: "io.endlessfall.evil"),
        Character(name: "uwu ball", character: AnyView(ShockedBall()), cost: "Free", characterID: "io.endlessfall.shocked"),
        Character(name: "basketball", character: AnyView(BasketBall()), cost: "Free", characterID: "io.endlessfall.basketball"),
        Character(name: "soccer ball", character: AnyView(SoccerBall()), cost: "Free", characterID: "io.endlessfall.soccer"),
        Character(name: "voleyball", character: AnyView(VolleyBall()), cost: "Free", characterID: "io.endlessfall.volleyball"),
        Character(name: "disco ball", character: AnyView(DiscoBall()), cost: "20", characterID: "io.endlessfall.disco"),
        Character(name: "pool ball", character: AnyView(PoolBall()), cost: "20", characterID: "io.endlessfall.poolball"),
        Character(name: "tennis ball", character: AnyView(TennisBall()), cost: "20", characterID: "io.endlessfall.tennis"),
        Character(name: "china ball", character: AnyView(ChinaView()), cost: "50", characterID: "io.endlessfall.china"),
        Character(name: "america ball", character: AnyView(AmericaView()), cost: "50", characterID: "io.endlessfall.america"),
        Character(name: "india ball", character: AnyView(IndiaView()), cost: "50", characterID: "io.endlessfall.india"),
        Character(name: "japan ball", character: AnyView(JapanView()), cost: "50", characterID: "io.endlessfall.japan"),
        Character(name: "UK ball", character: AnyView(UkView()), cost: "50", characterID: "io.endlessfall.uk"),
        Character(name: "germany ball", character: AnyView(GermanyView()), cost: "50", characterID: "io.endlessfall.germany"),
        Character(name: "france ball", character: AnyView(FranceView()), cost: "50", characterID: "io.endlessfall.france"),
        Character(name: "canada ball", character: AnyView(CanadaView()), cost: "50", characterID: "io.endlessfall.canada"),
        Character(name: "brazil ball", character: AnyView(BrazilView()), cost: "50", characterID: "io.endlessfall.brazil"),
        Character(name: "paraguay ball", character: AnyView(ParaguayView()), cost: "50", characterID: "io.endlessfall.paraguay"),
        Character(name: "colombia ball", character: AnyView(ColombiaView()), cost: "50", characterID: "io.endlessfall.colombia"),
        Character(name: "south korea ball", character: AnyView(SouthKoreaView()), cost: "50", characterID: "io.endlessfall.southkorea"),
        Character(name: "mexico ball", character: AnyView(MexicoView()), cost: "50", characterID: "io.endlessfall.mexico"),
        Character(name: "portugal ball", character: AnyView(PortugalView()), cost: "50", characterID: "io.endlessfall.portugal"),
        Character(name: "spain ball", character: AnyView(SpainView()), cost: "50", characterID: "io.endlessfall.spain"),
        Character(name: "saudi arabia ball", character: AnyView(SaudiArabiaView()), cost: "50", characterID: "io.endlessfall.saudiarabia"),
        Character(name: "UAE ball", character: AnyView(UaeView()), cost: "50", characterID: "io.endlessfall.uae"),
        Character(name: "qatar ball", character: AnyView(QatarView()), cost: "50", characterID: "io.endlessfall.qatar"),
        Character(name: "ethiopia ball", character: AnyView(EthiopiaView()), cost: "50", characterID: "io.endlessfall.ethiopia"),
        Character(name: "nigeria ball", character: AnyView(NigeriaView()), cost: "50", characterID: "io.endlessfall.nigeria"),
        Character(name: "south africa ball", character: AnyView(SouthAfricaView()), cost: "50", characterID: "io.endlessfall.southafrica"),
        Character(name: "russia ball", character: AnyView(RussiaView()), cost: "50", characterID: "io.endlessfall.russia"),
        Character(name: "belarus ball", character: AnyView(BelarusView()), cost: "50", characterID: "io.endlessfall.belarus"),
        Character(name: "poland ball", character: AnyView(PolandView()), cost: "50", characterID: "io.endlessfall.poland"),
        Character(name: "ukraine ball", character: AnyView(UkraineView()), cost: "50", characterID: "io.endlessfall.ukraine"),
        Character(name: "finland ball", character: AnyView(FinlandView()), cost: "50", characterID: "io.endlessfall.finland"),
        Character(name: "sweden ball", character: AnyView(SwedenView()), cost: "50", characterID: "io.endlessfall.sweden"),
        Character(name: "norway ball", character: AnyView(NorwayView()), cost: "50", characterID: "io.endlessfall.norway"),
        Character(name: "denmark ball", character: AnyView(DenmarkView()), cost: "50", characterID: "io.endlessfall.denmark"),
        Character(name: "estonia ball", character: AnyView(EstoniaView()), cost: "50", characterID: "io.endlessfall.estonia"),
        Character(name: "italy ball", character: AnyView(ItalyView()), cost: "50", characterID: "io.endlessfall.italy"),
        Character(name: "greece ball", character: AnyView(GreeceView()), cost: "50", characterID: "io.endlessfall.greece"),
        Character(name: "turkey ball", character: AnyView(TurkeyView()), cost: "50", characterID: "io.endlessfall.turkey"),
        Character(name: "somalia ball", character: AnyView(SomaliaView()), cost: "50", characterID: "io.endlessfall.somalia"),
        Character(name: "kenya ball", character: AnyView(KenyaView()), cost: "50", characterID: "io.endlessfall.kenya"),
        Character(name: "tanzania ball", character: AnyView(TanzaniaView()), cost: "50", characterID: "io.endlessfall.tanzania"),
        Character(name: "thailand ball", character: AnyView(ThailandView()), cost: "50", characterID: "io.endlessfall.thailand"),
        Character(name: "vietnam ball", character: AnyView(VietnamView()), cost: "50", characterID: "io.endlessfall.vietnam"),
        Character(name: "malaysia ball", character: AnyView(MalaysiaView()), cost: "50", characterID: "io.endlessfall.malaysia"),
        Character(name: "chile ball", character: AnyView(ChileView()), cost: "50", characterID: "io.endlessfall.chile"),
        Character(name: "argentina ball", character: AnyView(ArgentinaView()), cost: "50", characterID: "io.endlessfall.argentina"),
        Character(name: "peru ball", character: AnyView(PeruView()), cost: "50", characterID: "io.endlessfall.peru"),
        Character(name: "pakistan ball", character: AnyView(PakistanView()), cost: "50", characterID: "io.endlessfall.pakistan"),
        Character(name: "bangladesh ball", character: AnyView(BangladeshView()), cost: "50", characterID: "io.endlessfall.bangladesh"),
        Character(name: "indonesia ball", character: AnyView(IndonesiaView()), cost: "50", characterID: "io.endlessfall.indonesia"),
        Character(name: "egypt ball", character: AnyView(EgyptView()), cost: "50", characterID: "io.endlessfall.egypt"),
        Character(name: "palestine ball", character: AnyView(PalestineView()), cost: "50", characterID: "io.endlessfall.palestine"),
        Character(name: "morocco ball", character: AnyView(MoroccoView()), cost: "50", characterID: "io.endlessfall.morocco"),
        Character(name: "iran ball", character: AnyView(IranView()), cost: "50", characterID: "io.endlessfall.iran"),
        Character(name: "armenia ball", character: AnyView(ArmeniaView()), cost: "50", characterID: "io.endlessfall.armenia"),
        Character(name: "afghanistan ball", character: AnyView(AfghanistanView()), cost: "50", characterID: "io.endlessfall.afghanistan"),
        Character(name: "unicorn ball", character: AnyView(UnicornView()), cost: "100", characterID: "io.endlessfall.unicorn"),
        Character(name: "earth ball", character: AnyView(EarthBallView()), cost: "100", characterID: "io.endlessfall.earth"),
        Character(name: "beach ball", character: AnyView(BeachBallView()), cost: "100", characterID: "io.endlessfall.beachball"),
        Character(name: "joe rogan ball", character: AnyView(JoeRoganView()), cost: "100", characterID: "io.endlessfall.joerogan"),
        Character(name: "dj khaled ball", character: AnyView(DjkhaledView()), cost: "100", characterID: "io.endlessfall.djkhaled"),
        Character(name: "obama ball", character: AnyView(ObamaView()), cost: "100", characterID: "io.endlessfall.obama"),
        Character(name: "albert einstein ball", character: AnyView(AlbertView()), cost: "100", characterID: "io.endlessfall.albert"),
        Character(name: "monkey ball", character: AnyView(MonkeyView()), cost: "100", characterID: "io.endlessfall.monkey"),
        Character(name: "ice spice ball", character: AnyView(IceSpiceView()), cost: "100", characterID: "io.endlessfall.icespice"),
        Character(name: "kanye ball", character: AnyView(KanyeView()), cost: "100", characterID: "io.endlessfall.kanye"),
        Character(name: "ninja ball", character: AnyView(NinjaBallView()), cost: "100", characterID: "io.endlessfall.ninja"),
        Character(name: "elon musk ball", character: AnyView(ElonView()), cost: "100", characterID: "io.endlessfall.elon"),
        Character(name: "kai cenat ball", character: AnyView(KaiView()), cost: "100", characterID: "io.endlessfall.kai"),
        Character(name: "rick ball", character: AnyView(RickView()), cost: "100", characterID: "io.endlessfall.rick"),
        Character(name: "morty ball", character: AnyView(MortyView()), cost: "100", characterID: "io.endlessfall.morty"),
        Character(name: "yeat ball", character: AnyView(YeatView()), cost: "100", characterID: "io.endlessfall.yeat"),
        Character(name: "one piece ball", character: AnyView(OnepieceView()), cost: "100", characterID: "io.endlessfall.onepiece"),
        Character(name: "all might ball", character: AnyView(AllmightView()), cost: "100", characterID: "io.endlessfall.allmight"),
        Character(name: "pearl ball", character: AnyView(PearlBallView()), cost: "300", characterID: "io.endlessfall.pearl"),
        Character(name: "gold ball", character: AnyView(GoldBallView()), cost: "700", characterID: "io.endlessfall.gold"),
        Character(name: "diamond ball", character: AnyView(DiamondBallView()), cost: "1000", characterID: "io.endlessfall.diamond")
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
    let name: String
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

struct CustomShadowModifier: ViewModifier {
    var strokeSize: CGFloat = 1
    var radius: CGFloat = 0.3
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .shadow(color: .black, radius: radius, x: -strokeSize, y: 0)
            .shadow(color: .black, radius: radius, x: -strokeSize, y: -strokeSize)
            .shadow(color: .black, radius: radius, x: -strokeSize, y: strokeSize)
            .shadow(color: .black, radius: radius, x: 0, y: -1)
            .shadow(color: .black, radius: radius, x: 0, y: 1)
            .shadow(color: .black, radius: radius, x: strokeSize, y: strokeSize)
            .shadow(color: .black, radius: radius, x: strokeSize, y: 0)
            .shadow(color: .black, radius: radius, x: strokeSize, y: -strokeSize)
    }
}

extension View {
    func customShadow(radius: CGFloat = 0.3, width: CGFloat = 1) -> some View {
        self.modifier(CustomShadowModifier(strokeSize: width, radius: radius))
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

let impactHeavy = UIImpactFeedbackGenerator(style: .heavy)


struct RoundedAndShadowButtonStyle3:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .shadow(color: .black, radius: 0.1, x: configuration.isPressed ? 0 : -3, y: configuration.isPressed ? 0 : 3)
            .offset(x: configuration.isPressed ? -3 : 0, y: configuration.isPressed ? 3 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newPressSetting in
                impactHeavy.impactOccurred()
            }
    }
}

struct RoundedAndShadowButtonStyle6:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .shadow(color: .black, radius: 0.1, x: configuration.isPressed ? 0 : -6, y: configuration.isPressed ? 0 : 6)
            .offset(x: configuration.isPressed ? -6 : 0, y: configuration.isPressed ? 6 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newPressSetting in
                impactHeavy.impactOccurred()
            }
    }
}

struct RoundedAndShadowButtonStyle9:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .shadow(color: .black, radius: 0.1, x: configuration.isPressed ? 0 : -9, y: configuration.isPressed ? 0 : 9)
            .offset(x: configuration.isPressed ? -9 : 0, y: configuration.isPressed ? 9 : 0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newPressSetting in
                impactHeavy.impactOccurred()
            }
    }
}

struct CharacterMenuButtonStyle:ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .compositingGroup()
            .scaleEffect(configuration.isPressed ? 0.85 : 1)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
            .onChange(of: configuration.isPressed) { newPressSetting in
                impactHeavy.impactOccurred()
            }
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle6 {
    static var roundedAndShadow6:RoundedAndShadowButtonStyle6 {
        RoundedAndShadowButtonStyle6()
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle3 {
    static var roundedAndShadow3:RoundedAndShadowButtonStyle3 {
        RoundedAndShadowButtonStyle3()
    }
}

extension ButtonStyle where Self == RoundedAndShadowButtonStyle9 {
    static var roundedAndShadow9:RoundedAndShadowButtonStyle9 {
        RoundedAndShadowButtonStyle9()
    }
}

extension ButtonStyle where Self == CharacterMenuButtonStyle {
    static var characterMenu:CharacterMenuButtonStyle {
        CharacterMenuButtonStyle()
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
                "iPhone SE",
                "iPhone SE (2nd generation)",
                "iPhone SE (3rd generation)"// Assuming this is the 1st generation iPhone SE
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

extension Array {
    func randomElement(randomCount: Int) -> [Element] {
        return (0..<2).compactMap { _ in self.randomElement() }
    }
}

extension UnitPoint {
    static var random: UnitPoint {
        return UnitPoint(x: CGFloat(Int.random(in: 0...1)), y: CGFloat(Int.random(in: 0...1)))
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
