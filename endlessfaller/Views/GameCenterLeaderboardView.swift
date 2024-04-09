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
    @ObservedObject private var model = AppModel.sharedAppModel
    @ObservedObject var gameCenter = GameCenter.shared
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var localPlayer = GKLocalPlayer.local
    @State var selectedLeaderboard = 0
    
    
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
            RandomGradientView()
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
                        .customTextStroke(width: 1.5)
                        .offset(y: 6)
                }
                VStack{
                    //if playersList.isEmpty{
                        ZStack{
                                ZStack{
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
                                        .font(.title3)
                                        .bold()
                                        .italic()
                                        .customTextStroke()
                                        
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
                                                                .padding([.horizontal, .top])
                                                                .overlay{
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if todaysPlayersList.count > 2 {
                                                                Text(todaysPlayersList[2].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    .padding(.horizontal)
                                                                Text(String(todaysPlayersList[2].score))
                                                                    .customTextStroke(width: 1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        .background{
                                                            if todaysPlayersList.count > 2 {
                                                                if todaysPlayersList[2].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        .cornerRadius(21)
                                                        .padding(.leading)
                                                        .offset(y: 120)
                                                        .padding(.bottom, 30)
                                                        VStack{
                                                            Text("👑")
                                                                .font(.largeTitle)
                                                                .scaleEffect(1.5)
                                                                .opacity(todaysPlayersList.count > 0 ? 1 : 0)
                                                                .customTextStroke()
                                                            Circle()
                                                                .frame(width: 100)
                                                                .foregroundColor(todaysPlayersList.count > 0 ? .clear : .gray)
                                                                .padding([.horizontal])
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if todaysPlayersList.count > 0 {
                                                                Text(todaysPlayersList[0].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    
                                                                    .padding(.horizontal)
                                                                Text(String(todaysPlayersList[0].score))
                                                                    .customTextStroke(width: 1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                            }
                                                        }
                                                        .background{
                                                            if todaysPlayersList.count > 0 {
                                                                if todaysPlayersList[0].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .cornerRadius(21)
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(todaysPlayersList.count > 1  ? .clear : .gray)
                                                                .padding([.horizontal, .top])
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if todaysPlayersList.count > 1 {
                                                                Text(todaysPlayersList[1].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    .padding(.horizontal)
                                                                Text(String(todaysPlayersList[1].score))
                                                                    .customTextStroke(width: 1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                            }
                                                        }
                                                        .background{
                                                            if todaysPlayersList.count > 1 {
                                                                if todaysPlayersList[1].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        .cornerRadius(21)
                                                        .padding(.trailing)
                                                        .offset(y: 120)
                                                        .padding(.bottom, 30)
                                                    }
                                                    .padding(.bottom, 60)
                                                    .background{
                                                        RotatingSunView()
                                                            .offset(y:240)
                                                    }
                                                    List {
                                                        ForEach(4...50, id: \.self) { num in
                                                            ZStack{
                                                                HStack{
                                                                    Text("\(num)")
                                                                        .customTextStroke()
                                                                        .bold()
                                                                        .italic()
                                                                    VStack(alignment: .leading){
                                                                        if todaysPlayersList.count > num - 1 {
                                                                            Text(todaysPlayersList[num - 1].name)
                                                                                .customTextStroke()
                                                                                .font(.caption)
                                                                                .bold()
                                                                                .italic()
                                                                            //                                                                                .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                        }
                                                                        
                                                                    }
                                                                    .offset(x: 80)
                                                                    Spacer()
                                                                    Text(todaysPlayersList.count > num - 1 ? String(todaysPlayersList[num - 1].score) : "-")
                                                                        .customTextStroke()
                                                                        .bold()
                                                                        .italic()
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
                                                            .listRowBackground(RandomGradientView())
                                                        }
                                                        
                                                    }
                                                    .allowsHitTesting(false)
                                                    .frame(width: self.idiom == .pad ? deviceWidth / 1.5 : deviceWidth, height: 3400, alignment: .center)
                                                    .scrollContentBackground(.hidden)
                                                }
                                                .refreshable {
                                                    Task{
                                                        await gameCenter.loadLeaderboard()
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
                                                    HStack{
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(allTimePlayersList.count > 2 ? .clear : .gray)
                                                                .padding([.horizontal, .top])
                                                                .overlay{
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if allTimePlayersList.count > 2 {
                                                                Text(allTimePlayersList[2].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    .padding(.horizontal)
                                                                Text(String(allTimePlayersList[2].score))
                                                                    .customTextStroke(width: 1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        .background{
                                                            if allTimePlayersList.count > 2 {
                                                                if allTimePlayersList[2].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .cornerRadius(21)
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        .padding(.leading)
                                                        .offset(y: 120)
                                                        .padding(.bottom, 30)
                                                        VStack{
                                                            Text("👑")
                                                                .font(.largeTitle)
                                                                .scaleEffect(1.5)
                                                                .opacity(allTimePlayersList.count > 0 ? 1 : 0)
                                                                .customTextStroke()
                                                            Circle()
                                                                .frame(width: 100)
                                                                .foregroundColor(allTimePlayersList.count > 0 ? .clear : .gray)
                                                                .padding([.horizontal])
                                                                .overlay{
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if allTimePlayersList.count > 0 {
                                                                Text(allTimePlayersList[0].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    .padding(.horizontal)
                                                                Text(String(allTimePlayersList[0].score))
                                                                    .customTextStroke(width: 1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                            }
                                                        }
                                                        .background{
                                                            if allTimePlayersList.count > 0 {
                                                                if allTimePlayersList[0].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .cornerRadius(21)
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        VStack{
                                                            Circle()
                                                                .frame(width: 90)
                                                                .foregroundColor(allTimePlayersList.count > 1  ? .clear : .gray)
                                                                .padding([.horizontal, .top])
                                                                .overlay{
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
                                                                .scaleEffect(1.2)
                                                                .customTextStroke()
                                                            if allTimePlayersList.count > 1 {
                                                                Text(allTimePlayersList[1].name)
                                                                    
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title3)
                                                                    .bold()
                                                                    .italic()
                                                                    .padding(.horizontal)
                                                                Text(String(allTimePlayersList[1].score))
                                                                    .customTextStroke(width:1.5)
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.title)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            } else{
                                                                Text("-")
                                                                    .customTextStroke()
                                                                    .multilineTextAlignment(.center)
                                                                    .font(.largeTitle)
                                                                    .bold()
                                                                    .italic()
                                                                //                                                                    .shadow(color: .black, radius: 1, x: -3, y: 3)
                                                            }
                                                        }
                                                        .background{
                                                            if allTimePlayersList.count > 1 {
                                                                if allTimePlayersList[1].currentPlayer.alias == localPlayer.alias {
                                                                    Color.white
                                                                        .opacity(0.3)
                                                                }
                                                            }
                                                        }
                                                        .cornerRadius(21)
                                                        .frame(maxWidth: deviceWidth / 3)
                                                        .padding(.trailing)
                                                        .offset(y: 120)
                                                        .padding(.bottom, 30)
                                                    }
                                                    .padding(.bottom, 60)
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
                                                                        .customTextStroke()
                                                                        .bold()
                                                                        .italic()
                                                                    VStack(alignment: .leading){
                                                                        if allTimePlayersList.count > num - 1 {
                                                                            Text(allTimePlayersList[num - 1].name)
                                                                                .font(.caption)
                                                                                .customTextStroke()
                                                                                .bold()
                                                                                .italic()
                                                                            //                                                                                .shadow(color: .black, radius: 1, x: -1, y: 1)
                                                                        }
                                                                        
                                                                    }
                                                                    .offset(x: 80)
                                                                    Spacer()
                                                                    Text(allTimePlayersList.count > num - 1 ? String(allTimePlayersList[num - 1].score) : "-")
                                                                        .customTextStroke()
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
                                                            .listRowBackground(RandomGradientView())
                                                        }
                                                        
                                                    }
                                                    .allowsHitTesting(false)
                                                    .frame(width: self.idiom == .pad ? deviceWidth / 1.5 : deviceWidth, height: 3400, alignment: .center)
                                                    .scrollContentBackground(.hidden)
                                                }
                                                .refreshable {
                                                    Task{
                                                        await gameCenter.loadLeaderboard()
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
                        .ignoresSafeArea()
                }
            }
            if !GKLocalPlayer.local.isAuthenticated {
                LeaderboardInfoView()
            }
        }
        .onAppear{
            Task{
                await gameCenter.loadLeaderboard()
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
    GameCenterLeaderboardView()
}
