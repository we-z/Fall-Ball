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
    let deviceHeight = UIScreen.main.bounds.height
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
    let leaderboardIdentifier = "fallball.leaderboard"
    @State var isGameCenterEnabled: Bool = false
    @State var timeLeft = 0.0
    @Binding  var backgroundColor: Color
    @State var selectedLeaderboard = 0
    
    public init(backgroundColor: Binding<Color>) {
        _backgroundColor = backgroundColor
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
        let todaysPlayersList = gameCenter.todaysPlayersList
        let allTimePlayersList = gameCenter.allTimePlayersList
        ZStack{
            backgroundColor
                .overlay(.black.opacity(0.2))
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
                        .foregroundColor(.white)
                            .shadow(color: .black, radius: 1, x: -3, y: 3)
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
                                        .overlay(.black.opacity(0.2))
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
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .bold()
                                        .italic()
                                            .shadow(color: .black, radius: 1, x: -3, y: 3)
                                        TabView(selection: $selectedLeaderboard){
                                            ZStack{
                                                ScrollView(showsIndicators: false) {
                                                    //                                                    Text(formatTimeDuration(timeLeft))
                                                    //                                                        .foregroundColor(.white)
                                                    //                                                        .bold()
                                                    //                                                        .italic()
                                                    HStack{
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(todaysPlayersList.count > 2 ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
                                                                    //                                                                    YinYangBallView()
                                                                    //                                                                        .scaleEffect(2)
                                                                    if todaysPlayersList.count > 2 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == todaysPlayersList[2].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 90))
                                                                        }
                                                                    }
                                                                }
                                                            Text("🥉")
                                                                .font(.largeTitle)
                                                            if todaysPlayersList.count > 2 {
                                                                Text(todaysPlayersList[2].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(todaysPlayersList[2].score))
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
                                                                .opacity(todaysPlayersList.count > 0 ? 1 : 0)
                                                            Circle()
                                                                .frame(width: 100)
                                                                .foregroundColor(todaysPlayersList.count > 0 ? .clear : .gray)
                                                                .overlay{
                                                                    //                                                                    RickView()
                                                                    //                                                                        .scaleEffect(2.7)
                                                                    if todaysPlayersList.count > 0 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == todaysPlayersList[0].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 100))
                                                                        }
                                                                    }
                                                                }
                                                            Text("🥇")
                                                                .font(.largeTitle)
                                                            if todaysPlayersList.count > 0 {
                                                                Text(todaysPlayersList[0].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(todaysPlayersList[0].score))
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
                                                                .foregroundColor(todaysPlayersList.count > 1  ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
                                                                    //                                                                    IceSpiceView()
                                                                    //                                                                        .scaleEffect(2)
                                                                    if todaysPlayersList.count > 1 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == todaysPlayersList[1].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 90))
                                                                        }
                                                                    }
                                                                }
                                                            Text("🥈")
                                                                .font(.largeTitle)
                                                            if todaysPlayersList.count > 1 {
                                                                Text(todaysPlayersList[1].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(todaysPlayersList[1].score))
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
                                                    .background{
                                                        RotatingSunView()
                                                            .offset(y:240)
                                                    }
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
                                                                        if todaysPlayersList.count > num - 1 {
                                                                            Text(todaysPlayersList[num - 1].name)
                                                                                .font(.caption)
                                                                                .bold()
                                                                                .italic()
                                                                            //                                                                                .foregroundColor(.white)
                                                                            //                                                                                .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                        }
                                                                        
                                                                    }
                                                                    .offset(x: 80)
                                                                    Spacer()
                                                                    Text(todaysPlayersList.count > num - 1 ? String(todaysPlayersList[num - 1].score) : "-")
                                                                        .bold()
                                                                        .italic()
                                                                    //                                                                        .foregroundColor(.white)
                                                                    //                                                                        .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                }
                                                                if todaysPlayersList.count > num - 1 {
                                                                    if let character = model.characters.first(where: {$0.characterID.hash == todaysPlayersList[num - 1].ballID}) {
                                                                        AnyView(character.character)
                                                                            .position(x: 55, y: 30)
                                                                    } else {
                                                                        Image(systemName: "questionmark.circle")
                                                                            .font(.system(size: 40))
                                                                            .position(x: 55, y: 30)
                                                                    }
                                                                } else {
                                                                    WhiteBallView()
                                                                        .opacity(0.5)
                                                                        .position(x: 55, y: 30)
                                                                }
                                                                
                                                            }
                                                            .listRowBackground(backgroundColor)
                                                        }
                                                        
                                                    }
                                                    .allowsHitTesting(false)
                                                    .frame(width: g.size.width, height: 3400, alignment: .center)
                                                    .scrollContentBackground(.hidden)
                                                }
                                                .refreshable {
                                                    Task{
                                                        await gameCenter.loadLeaderboard(source: 4)
                                                    }
                                                }
                                                if todaysPlayersList.isEmpty{
                                                    ProgressView()
                                                        .scaleEffect(3)
                                                }
                                            }
                                            .tag(0)
                                            ZStack{
                                                ScrollView(showsIndicators: false) {
                                                    //                                                    Text(formatTimeDuration(timeLeft))
                                                    //                                                        .foregroundColor(.white)
                                                    //                                                        .bold()
                                                    //                                                        .italic()
                                                    HStack{
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(allTimePlayersList.count > 2 ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
                                                                    //                                                                    YinYangBallView()
                                                                    //                                                                        .scaleEffect(2)
                                                                    if allTimePlayersList.count > 2 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == allTimePlayersList[2].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 90))
                                                                        }
                                                                    }
                                                                }
                                                            Text("🥉")
                                                                .font(.largeTitle)
                                                            if allTimePlayersList.count > 2 {
                                                                Text(allTimePlayersList[2].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(allTimePlayersList[2].score))
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
                                                                .opacity(allTimePlayersList.count > 0 ? 1 : 0)
                                                            Circle()
                                                                .frame(width: 100)
                                                                .foregroundColor(allTimePlayersList.count > 0 ? .clear : .gray)
                                                                .overlay{
                                                                    //                                                                    RickView()
                                                                    //                                                                        .scaleEffect(2.7)
                                                                    if allTimePlayersList.count > 0 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == allTimePlayersList[0].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 90))
                                                                        }
                                                                    }
                                                                    
                                                                }
                                                            Text("🥇")
                                                                .font(.largeTitle)
                                                            if allTimePlayersList.count > 0 {
                                                                Text(allTimePlayersList[0].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(allTimePlayersList[0].score))
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
                                                                .foregroundColor(allTimePlayersList.count > 1  ? .clear : .gray)
                                                                .padding(.horizontal)
                                                                .overlay{
                                                                    //                                                                    IceSpiceView()
                                                                    //                                                                        .scaleEffect(2)
                                                                    if allTimePlayersList.count > 1 {
                                                                        if let character = model.characters.first(where: {$0.characterID.hash == allTimePlayersList[1].ballID}) {
                                                                            AnyView(character.character)
                                                                                .scaleEffect(2)
                                                                        } else {
                                                                            Image(systemName: "questionmark.circle")
                                                                                .font(.system(size: 90))
                                                                        }
                                                                    }
                                                                }
                                                            Text("🥈")
                                                                .font(.largeTitle)
                                                            if allTimePlayersList.count > 1 {
                                                                Text(allTimePlayersList[1].name)
                                                                //                                                                    .foregroundStyle(.white)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                                Text(String(allTimePlayersList[1].score))
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
                                                    .background{
                                                        RotatingSunView()
                                                            .offset(y:240)
                                                    }
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
                                                                        if allTimePlayersList.count > num - 1 {
                                                                            Text(allTimePlayersList[num - 1].name)
                                                                                .font(.caption)
                                                                                .bold()
                                                                                .italic()
                                                                            //                                                                                .foregroundColor(.white)
                                                                            //                                                                                .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                        }
                                                                        
                                                                    }
                                                                    .offset(x: 80)
                                                                    Spacer()
                                                                    Text(allTimePlayersList.count > num - 1 ? String(allTimePlayersList[num - 1].score) : "-")
                                                                        .bold()
                                                                        .italic()
                                                                    //                                                                        .foregroundColor(.white)
                                                                    //                                                                        .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                }
                                                                if allTimePlayersList.count > num - 1 {
                                                                    if let character = model.characters.first(where: {$0.characterID.hash == allTimePlayersList[num - 1].ballID}) {
                                                                        AnyView(character.character)
                                                                            .position(x: 55, y: 30)
                                                                    } else {
                                                                        Image(systemName: "questionmark.circle")
                                                                            .font(.system(size: 40))
                                                                            .position(x: 55, y: 30)
                                                                    }
                                                                } else {
                                                                    WhiteBallView()
                                                                        .opacity(0.5)
                                                                        .position(x: 55, y: 30)
                                                                }
                                                                
                                                            }
                                                            .listRowBackground(backgroundColor)
                                                        }
                                                        
                                                    }
                                                    .allowsHitTesting(false)
                                                    .frame(width: g.size.width, height: 3400, alignment: .center)
                                                    .scrollContentBackground(.hidden)
                                                }
                                                .refreshable {
                                                    Task{
                                                        await gameCenter.loadLeaderboard(source: 4)
                                                    }
                                                }
                                                if allTimePlayersList.isEmpty{
                                                    ProgressView()
                                                        .scaleEffect(3)
                                                }
                                            }
                                            .tag(1)
                                        }
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    }
                                }
                            }
                        }
                        .ignoresSafeArea()
                }
            }
        }
        .onAppear(){
            
            if !GKLocalPlayer.local.isAuthenticated {
                gameCenter.authenticateUser()
            } else if todaysPlayersList.count == 0 {
                Task{
                    await gameCenter.loadLeaderboard(source: 1)
                }
            }
            
        }
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
    GameCenterLeaderboardView(backgroundColor: .constant(Color.brown))
}
