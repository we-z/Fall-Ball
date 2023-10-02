//
//  GameCenterLeaderboardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/26/23.
//
import SwiftUI
import CloudKit
import GameKit

struct GameCenterLeaderboardView: View {
    let deviceWidth = UIScreen.main.bounds.width
    @StateObject var model = AppModel()
    @StateObject private var CKVM = CloudKitCrud()
    @ObservedObject var gameCenter = GameCenter()
    @State var place = 1
    @State var unserNameTextField = ""
    @State var recordID: CKRecord.ID? = nil
    @AppStorage(userNameKey) var myUserName: String = (UserDefaults.standard.string(forKey: userNameKey) ?? "")
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @FocusState var isTextFieldFocused: Bool
    @State private var isGameCenterSheetPresented = false
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var localPlayer = GKLocalPlayer.local
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState:GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @State var playersList: [Player] = []
    let leaderboardIdentifier = "fallball.leaderboard"
    @State var isGameCenterEnabled: Bool = false
    @State var timeLeft = 0.0
    @Binding  var backgroundColor: Color
    @State var selectedLeaderboard = 0
    
    public init(backgroundColor: Binding<Color>) {
        _backgroundColor = backgroundColor
    }
    
    func loadLeaderboard(source: Int = 0) async {
        print("source:")
        print(source)
        playersList.removeAll()
        Task{
            var playersListTemp : [Player] = []
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [self.leaderboardIdentifier])
            if let leaderboard = leaderboards.filter ({ $0.baseLeaderboardID == self.leaderboardIdentifier }).first {
                let allPlayers = try await leaderboard.loadEntries(for: .global, timeScope: .allTime, range: NSRange(1...50))
                timeLeft = leaderboard.nextStartDate!.timeIntervalSinceNow
                if allPlayers.1.count > 0 {
                    print("players seen")
                    allPlayers.1.forEach { leaderboardEntry in
                        playersListTemp.append(Player(name: leaderboardEntry.player.displayName, score:leaderboardEntry.score, ballID: leaderboardEntry.context, currentPlayer: leaderboardEntry.player, rank: leaderboardEntry.rank))
                        //                                print("playersList")
                        //                                print(playersListTemp)
                        playersListTemp.sort{
                            $0.score > $1.score
                        }
                        
                        //                                playersList.sort()
                        //                                print("playersList")
                        //                                print(playersListTemp)
                        //TODO: Place this outside this loop
                        //                                playersList.sort{
                        //                                    $0.score < $1.score
                        //                                }
                    }
                } else {
                    print("players not seen")
                }
            } else {
                print("the code never worked")
                print("leaderboards:")
                print(leaderboards)
            }
            print("playersList:")
            print(playersListTemp)
            playersList = playersListTemp
        }
    }
    
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            Task{
                await loadLeaderboard(source: 3)
            }
        }
    }
    
    func formatTimeDuration(_ duration: Double) -> String {
        let seconds = Int(duration)
        let minutes = (seconds / 60) % 60
        let hours = (seconds / 3600)
        
        var formattedTime = "Time Left: "
        
        if hours > 0 {
            formattedTime += "\(hours)h "
        }
        
        if minutes > 0 {
            formattedTime += "\(minutes)m "
        }
        
        formattedTime += "\(seconds % 60)s"
        
        return formattedTime
    }
    
    var body: some View {
        if isGKActive{
            GameCenterView(format: gameCenterViewControllerState)
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
                   .navigationBarItems(leading: Text(""))
        } else {
            ZStack{
                backgroundColor
                    .overlay(.black.opacity(0))
                    .ignoresSafeArea()
                VStack{
                    Capsule()
                        .frame(maxWidth: 45, maxHeight: 9)
                        .padding(.top, 9)
                        .foregroundColor(.black)
                        .opacity(0.3)
                    HStack{
                        Text("🏆 LEADERBOARD 🏆")
                            .bold()
                            .italic()
                            .font(.title)
                            .foregroundColor(.black)
//                            .shadow(color: .black, radius: 1, x: -3, y: 3)
                            .offset(y: 6)
                    }
                    VStack{
                        //if playersList.isEmpty{
                            ZStack{
                                backgroundColor
                                    .overlay(.black.opacity(0.1))
                                GeometryReader { g in
                                    ZStack{
                                        backgroundColor
                                            .overlay(.black.opacity(0))
                                        VStack{
                                            HStack{
                                                Button {
                                                    withAnimation{
                                                        self.selectedLeaderboard = 0
                                                    }
                                                } label: {
                                                    Text("TODAY")
                                                        .opacity(selectedLeaderboard == 0 ? 1 : 0.5)
                                                        .padding(.leading)
                                                }
                                                Button {
                                                    withAnimation{
                                                        self.selectedLeaderboard = 1
                                                    }
                                                } label: {
                                                    
                                                    Text("ALL TIME")
                                                        .opacity(selectedLeaderboard == 1 ? 1 : 0.5)
                                                        .padding(.leading)
                                                }
                                            }
                                            .foregroundColor(.black)
                                            .font(.title3)
                                            .bold()
                                            .italic()
//                                            .shadow(color: .black, radius: 1, x: -3, y: 3)
                                            TabView(selection: $selectedLeaderboard){
                                                ScrollView(showsIndicators: false) {
//                                                    Text(formatTimeDuration(timeLeft))
//                                                        .foregroundColor(.white)
//                                                        .bold()
//                                                        .italic()
                                                    HStack{
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(playersList.count > 2 ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
//                                                                    YinYangBallView()
//                                                                        .scaleEffect(2)
                                                                    if playersList.count > 2 {
                                                                        let character = model.characters[playersList[2].ballID]
                                                                        AnyView(character.character)
                                                                            .scaleEffect(2)
                                                                    }
                                                                }
                                                            Text("🥉")
                                                                .font(.largeTitle)
                                                            if playersList.count > 2 {
                                                                Text(playersList[2].name)
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(playersList[2].score))
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            } else{
                                                                Text("-")
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        .padding(.leading)
                                                        .offset(y: 90)
                                                        .padding(.bottom, 30)
                                                        VStack{
                                                            Text("👑")
                                                                .font(.largeTitle)
                                                            Circle()
                                                                .frame(width: 100)
                                                                .foregroundColor(playersList.count > 0 ? .clear : .gray)
                                                                .overlay{
//                                                                    RickView()
//                                                                        .scaleEffect(2.7)
                                                                    if playersList.count > 0 {
                                                                        let character = model.characters[playersList[0].ballID]
                                                                        AnyView(character.character)
                                                                            .scaleEffect(2.7)
                                                                    }
                                                                    
                                                                }
                                                            Text("🥇")
                                                                .font(.largeTitle)
                                                            if playersList.count > 0 {
                                                                Text(playersList[0].name)
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(playersList[0].score))
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            } else{
                                                                Text("-")
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(playersList.count > 1  ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
//                                                                    IceSpiceView()
//                                                                        .scaleEffect(2)
                                                                    if playersList.count > 1 {
                                                                        let character = model.characters[playersList[1].ballID]
                                                                        AnyView(character.character)
                                                                            .scaleEffect(2)
                                                                    }
                                                                }
                                                            Text("🥈")
                                                                .font(.largeTitle)
                                                            if playersList.count > 1 {
                                                                Text(playersList[1].name)
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(playersList[1].score))
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            } else{
                                                                Text("-")
//                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
//                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        .padding(.trailing)
                                                        .offset(y: 90)
                                                        .padding(.bottom, 30)
                                                    }
                                                    .padding(.bottom)
//                                                    .frame(height: 270)
                                                    List {
                                                        ForEach(4...50, id: \.self) { num in
                                                            ZStack{
                                                                HStack{
                                                                    Text("\(num)")
                                                                        .bold()
                                                                        .italic()
//                                                                        .foregroundColor(.white)
//                                                                        .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                    VStack(alignment: .leading){
                                                                        if playersList.count > num - 1 {
                                                                            Text(playersList[num - 1].name)
                                                                                .font(.caption)
                                                                                .bold()
                                                                                .italic()
//                                                                                .foregroundColor(.white)
//                                                                                .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                        }
                                                                            
                                                                    }
                                                                    .offset(x: 80)
                                                                    Spacer()
                                                                    Text(playersList.count > num - 1 ? String(playersList[num - 1].score) : "-")
                                                                        .bold()
                                                                        .italic()
//                                                                        .foregroundColor(.white)
//                                                                        .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                }
                                                                if playersList.count > num - 1 {
                                                                    let character = model.characters[playersList[num - 1].ballID]
                                                                    AnyView(character.character)
                                                                        .position(x: 55, y: 30)
                                                                } else {
                                                                    WhiteBallView()
                                                                        .opacity(0.5)
                                                                        .position(x: 55, y: 30)
                                                                }

                                                            }
                                                            .listRowBackground(backgroundColor.overlay(.black.opacity(0.15)))
                                                        }
                                                        
                                                    }
                                                    .allowsHitTesting(false)
                                                    .frame(width: g.size.width, height: 3400, alignment: .center)
                                                    .scrollContentBackground(.hidden)
                                                }
                                                .refreshable {
                                                    Task{
                                                        await loadLeaderboard(source: 4)
                                                    }
                                                }
                                                .tag(0)
                                                Text("Coming Soon!")
                                                    .font(.largeTitle)
//                                                    .foregroundColor(.white)
                                                    .bold()
                                                    .italic()
//                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                .tag(1)
                                            }
                                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                        }
                                        if playersList.isEmpty{
                                            ProgressView()
                                                .scaleEffect(3)
                                        }
                                    }
                                }
                            }
                            .ignoresSafeArea()
                                
//                        } else {
//                            ZStack{
//                                ScrollViewReader { value in
//                                    ScrollView(showsIndicators: false){
//                                        Text(formatTimeDuration(timeLeft))
//                                            .bold()
//                                            .padding(.top)
//                                        ForEach(Array(playersList.enumerated()), id: \.1.self) { index, player in
//                                            let place = index + 1
//                                            VStack{
//                                                ZStack{
//                                                    HStack{
//                                                        if place == 1 {
//                                                            Text("🥇 ")
//                                                                .padding(.leading)
//                                                                .font(.largeTitle)
//                                                                .scaleEffect(1.5)
//                                                                .offset(y: -9)
//                                                        } else if place == 2 {
//                                                            Text("🥈 ")
//                                                                .font(.largeTitle)
//                                                                .padding(.leading)
//                                                                .scaleEffect(1.5)
//                                                                .offset(y: -9)
//                                                        } else if place == 3 {
//                                                            Text("🥉 ")
//                                                                .font(.largeTitle)
//                                                                .padding(.leading)
//                                                                .scaleEffect(1.5)
//                                                                .offset(y: -9)
//                                                        } else {
//                                                            Text(String(place) + ":")
//                                                                .italic()
//                                                                .bold()
//                                                                .font(.title)
//                                                                .foregroundColor(.black)
//                                                                .frame(maxWidth: .infinity, alignment: .center)
//                                                                .position(x: 33, y: 45)
//                                                        }
//                                                        Spacer()
//                                                    }
//                                                    .offset(x: idiom == .pad ? deviceWidth * 0.1 : deviceWidth * 0.19, y: -15)
//                                                    if model.characters.count > player.ballID {
//                                                        let playerCharacter = model.characters[player.ballID]
//                                                        AnyView(playerCharacter.character)
//                                                            .padding(.horizontal)
//                                                            .frame(width: 95)
//                                                            .position(x: idiom == .pad ? deviceWidth * 0.1 : deviceWidth * 0.18, y: 50)
//                                                            .scaleEffect(1.2)
//                                                    } else {
//                                                        Image(systemName: "questionmark.circle")
//                                                            .font(.system(size: 55))
//                                                            .position(x: idiom == .pad ? deviceWidth * 0.05 : deviceWidth * 0.12, y: 50)
//                                                    }
//                                                    Text(player.name)
//                                                        .bold()
//                                                        .italic()
//                                                        .font(.title3)
//                                                        .foregroundColor(.black)
//                                                        .offset(x: idiom == .pad ? deviceWidth * 0.12 : deviceWidth * 0.24, y: 21)
//                                                        .frame(maxWidth: .infinity, alignment: .leading)
//                                                    Text(String(player.score))
//                                                        .bold()
//                                                        .italic()
//                                                        .font(.title)
//                                                        .foregroundColor(.black)
//                                                        .position(x: idiom == .pad ? deviceWidth * 0.6 : deviceWidth - 70, y: 50)
//                                                        .frame(maxWidth: .infinity, alignment: .center)
//                                                    if player.currentPlayer == localPlayer{
//                                                        Text("(You)")
//                                                            .bold()
//                                                            .font(.title2)
//                                                            .offset(y: -21)
//                                                    }
//                                                }
//                                            }
//                                            .frame(height: 100)
//                                            .background(.white)
//                                            .cornerRadius(20)
//                                            .shadow(radius: 2, y:2)
//                                            .overlay(
//                                                RoundedRectangle(cornerRadius: 20)
//                                                    .stroke(player.currentPlayer == localPlayer ? Color.black : .clear, lineWidth: 3)
//                                                    .flashing()
//                                            )
//                                            .padding(.top, 6)
//                                            .padding(.horizontal)
//                                            .id(index)
//                                            .onAppear{
//                                                if player.currentPlayer == localPlayer {
//                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
//                                                        withAnimation {
//                                                            value.scrollTo(index)
//                                                        }
//                                                    }
//                                                }
//                                            }
//                                        }
//                                        .padding(.top)
//                                    }
//                                    .refreshable {
//                                        Task{
//                                            await loadLeaderboard(source: 4)
//                                        }
//                                    }
//                                }
//                            }
//                            
//                        }
                    }
                }
            }
            .onAppear(){
                
                if !GKLocalPlayer.local.isAuthenticated {
                    authenticateUser()
                } else if playersList.count == 0 {
                    Task{
                        await loadLeaderboard(source: 1)
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    // 7.
                    withAnimation {
                        if !GKLocalPlayer.local.isAuthenticated {
                            authenticateUser()
                        } else if playersList.count == 0 {
                            Task{
                                await loadLeaderboard(source: 2)
                            }
                        }
                    }
                }
                
//                localPlayer.authenticateHandler = { [self] (gameCenterViewController, error) -> Void in
//                    // check if there are not error
//                    if error != nil {
//                        print(error!)
//                    } else if gameCenterViewController != nil {
//                        // 1. Show login if player is not logged in
//                        print("Show login")
//                        gameCenterViewControllerState = .leaderboards
//                        
//                    } else if (self.localPlayer.isAuthenticated) {
//                        // 2. Player is already authenticated & logged in, load game center
//                        self.isGameCenterEnabled = true
//                        isGKActive = true
//                        isGameCenterSheetPresented = true
//                    } else {
//                        // 3. Game center is not enabled on the users device
//                        self.isGameCenterEnabled = false
//                        print("Local player could not be authenticated!")
//                    }
//                }
//                if self.localPlayer.isAuthenticated {
//                    gameCenterViewControllerState = .leaderboards
//                    isGKActive = true
//                }
                
            }
            .sheet(isPresented: $isGameCenterSheetPresented) {
                GameCenterLoginView()
            }
        }
    }
}

struct GameCenterLoginView: UIViewControllerRepresentable {
    typealias UIViewControllerType = GKGameCenterViewController
    
    func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let gameCenterViewController = GKGameCenterViewController()
        gameCenterViewController.viewState = .leaderboards
        return gameCenterViewController
    }
    
    func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        // Update the view controller if needed
    }
}

public struct GameCenterView: UIViewControllerRepresentable {
    let viewController: GKGameCenterViewController
    @AppStorage("IsGameCenterActive") var isGKActive:Bool = false
    @Environment(\.presentationMode) var presentationMode

    public init(viewController: GKGameCenterViewController = GKGameCenterViewController(), format:GKGameCenterViewControllerState = .default ) {
        self.viewController = GKGameCenterViewController(state: format)
    }

    public func makeUIViewController(context: Context) -> GKGameCenterViewController {
        let gkVC = viewController
        gkVC.gameCenterDelegate = context.coordinator
        gkVC.navigationItem.hidesBackButton = true
        return gkVC
    }

    public func updateUIViewController(_ uiViewController: GKGameCenterViewController, context: Context) {
        return
    }

    public func makeCoordinator() -> GKCoordinator {
        return GKCoordinator(self)
    }
}

public class GKCoordinator: NSObject, GKGameCenterControllerDelegate {
    var view: GameCenterView

    init(_ gkView: GameCenterView) {
        self.view = gkView
    }

    public func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
        view.isGKActive = false
    }
}

struct Player: Hashable, Comparable {
    static func < (lhs: Player, rhs: Player) -> Bool {
        return rhs.score > lhs.score
    }
    
    let id = UUID()
    let name: String
    let score: Int
    let ballID: Int
    let currentPlayer: GKPlayer
    let rank: Int
}

#Preview {
    GameCenterLeaderboardView(backgroundColor: .constant(Color.white))
}
