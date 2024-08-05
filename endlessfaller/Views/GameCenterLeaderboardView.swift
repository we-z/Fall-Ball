//
//  GameCenterLeaderboardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/26/23.
//
import SwiftUI
import CloudKit
import GameKit
import WidgetKit

struct GameCenterLeaderboardView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var gameCenter = GameCenter.shared
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var localPlayer = GKLocalPlayer.local
    @State var selectedLeaderboard = 0
    @State var todayLeaderboardSelected = true
    @State var capsuleOffset = -45.0
    @State var capsuleWidth = 108.0
    @State var timeLeft = ""
    
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            timeLeft = formatTimeUntilNext5AM()
        }
    }

    func formatTimeUntilNext5AM() -> String {
        let calendar = Calendar.current
        let now = Date()
        var next5AMComponents = calendar.dateComponents([.year, .month, .day], from: now)
        next5AMComponents.hour = 5
        next5AMComponents.minute = 0
        next5AMComponents.second = 0

        var next5AM = calendar.date(from: next5AMComponents)!

        if next5AM <= now {
            next5AM = calendar.date(byAdding: .day, value: 1, to: next5AM)!
        }

        let duration = next5AM.timeIntervalSince(now)
        
        let seconds = Int(duration)
        let minutes = (seconds / 60) % 60
        let hours = (seconds / 3600)
        
        var formattedTime = "⏰ Time Left: "
        
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
                        .font(.system(size: 30))
                        .customTextStroke(width: 2.4)
                        .offset(y: 6)
                }
                VStack{
                    ZStack{
                        VStack{
                            Button {
                                self.todayLeaderboardSelected.toggle()
                            } label: {
                                ZStack{
                                    Capsule()
                                        .frame(width: 219, height: 48)
                                        .foregroundColor(.black)
                                        .clipShape(Capsule())
                                        .padding(.horizontal)
                                    Capsule()
                                        .frame(width: 210, height: 40)
                                        .foregroundColor(self.selectedLeaderboard == 0 ? .red : .blue)
                                        .clipShape(Capsule())
                                        .padding(.horizontal)
                                    Capsule()
                                        .frame(width: self.capsuleWidth, height: 30)
                                        .offset(x: capsuleOffset)
                                        .foregroundColor(.white)
                                        .padding(.horizontal)
                                    HStack{
                                        Text("ALL TIME")
                                            .padding(.leading)
                                        Text("TODAY")
                                            .padding(.leading)
                                        
                                    }
                                    .offset(x: -9)
                                    .font(.system(size: 20))
                                    .bold()
                                    .italic()
                                    .customTextStroke(width: 1.8)
                                }
                            }
                            .onChange(of: todayLeaderboardSelected) { todayLeaderboard in
                                if todayLeaderboard {
                                    withAnimation(){
                                        capsuleOffset = -45
                                        capsuleWidth = 108.0
                                        self.selectedLeaderboard = 0
                                    }
                                } else {
                                    withAnimation(){
                                        capsuleOffset = 55
                                        capsuleWidth = 90.0
                                        self.selectedLeaderboard = 1
                                    }
                                }
                            }
                            .onChange(of: selectedLeaderboard) { selected in
                                impactHeavy.impactOccurred()
                                if selected == 0 {
                                    withAnimation(){
                                        capsuleOffset = -45
                                        capsuleWidth = 108.0
                                    }
                                } else {
                                    withAnimation(){
                                        capsuleOffset = 55
                                        capsuleWidth = 90.0
                                    }
                                }
                            }
                            TabView(selection: $selectedLeaderboard){
                                LeaderboardView(playersList: gameCenter.allTimePlayersList)
                                .tag(0)
                                VStack{
                                   Text(timeLeft)
                                        .font(.system(size: 21))
                                        .customTextStroke(width: 1.5)
                                       .bold()
                                       .italic()
                                       .padding(.top, 3)
                                    LeaderboardView(playersList: gameCenter.todaysPlayersList)
                                }
                                .tag(1)
                            }
                            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        }
                    }
                    .onAppear {
                        startTimer()
                    }
                    .ignoresSafeArea()
                }
            }
            if gameCenter.allTimePlayersList.isEmpty {
                Button {
                    impactHeavy.impactOccurred()
                    openSettings()
                } label: {
                    LeaderboardInfoView()
                }
            }
        }
        .onAppear{
            impactHeavy.impactOccurred()
            Task{
                await gameCenter.loadLeaderboard()
            }
        }
    }
    
    func LeaderboardView (playersList: [Player]) -> some View {
        let PlayersList = playersList
        return ScrollView(showsIndicators: false) {
            LazyVStack{
                HStack{
                    VStack{
                        Circle()
                            .frame(width: 90)
                            .foregroundColor(PlayersList.count > 2 ? .clear : .gray)
                            .padding([.horizontal, .top])
                            .overlay{
                                if PlayersList.count > 2 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[2].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 90))
                                    }
                                }
                            }
                        Text("🥉")
                            .font(.system(size: 30))
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 2 {
                            Text(PlayersList[2].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[2].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.system(size: 30))
                                .bold()
                                .italic()
                        }
                    }
                    .frame(maxWidth: deviceWidth / 3)
                    .cornerRadius(21)
                    .padding(.leading)
                    .offset(y: 90)
                    .padding(.bottom, 30)
                    VStack{
                        Circle()
                            .frame(width: 100)
                            .foregroundColor(PlayersList.count > 0 ? .clear : .gray)
                            .padding([.horizontal])
                            .overlay{
                                if PlayersList.count > 0 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[0].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 100))
                                    }
                                }
                            }
                        Text("🥇")
                            .font(.system(size: 30))
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 0 {
                            Text(PlayersList[0].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[0].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.system(size: 30))
                                .bold()
                                .italic()
                        }
                    }
                    .cornerRadius(21)
                    .frame(maxWidth: deviceWidth / 3)
                    VStack{
                        Circle()
                            .frame(width: 90)
                            .foregroundColor(PlayersList.count > 1  ? .clear : .gray)
                            .padding([.horizontal, .top])
                            .overlay{
                                if PlayersList.count > 1 {
                                    if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[1].ballID}) {
                                        AnyView(character.character)
                                            .scaleEffect(2)
                                            .offset(y:3)
                                    } else {
                                        Image(systemName: "questionmark.circle")
                                            .font(.system(size: 90))
                                    }
                                }
                            }
                        Text("🥈")
                            .font(.system(size: 30))
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if PlayersList.count > 1 {
                            Text(PlayersList[1].name)
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .bold()
                                .italic()
                                .customShadow(radius: 0.1, width: 0.7)
                                .padding(.horizontal)
                            Text(String(PlayersList[1].score))
                                .customShadow(radius: 0.1, width: 1)
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .bold()
                                .italic()
                        } else{
                            Text("-")
                                .customTextStroke()
                                .multilineTextAlignment(.center)
                                .font(.system(size: 30))
                                .bold()
                                .italic()
                        }
                    }
                    .frame(maxWidth: deviceWidth / 3)
                    .cornerRadius(21)
                    .padding(.trailing)
                    .offset(y: 90)
                    .padding(.bottom, 30)
                }
                .padding(.bottom, 60)
                .background{
                    RotatingSunView()
                        .offset(y:270)
                }
                LazyVStack {
                    List {
                        ForEach(4...50, id: \.self) { num in
                            HStack{
                                Text("\(num)")
                                    .customTextStroke(width: 1.5)
                                    .bold()
                                    .italic()
                                    .font(.system(size: 21))
                                    .frame(width: 30)
                                    .offset(x: -6)
                                ZStack{
                                    if PlayersList.count > num - 1 {
                                        if let character = appModel.characters.first(where: {$0.characterID.hash == PlayersList[num - 1].ballID}) {
                                            AnyView(character.character)
                                        } else {
                                            Image(systemName: "questionmark.circle")
                                                .font(.system(size: 40))
                                        }
                                    } else {
                                        WhiteBallView()
                                            .opacity(0.5)
                                    }
                                }
                                .frame(width: 40)
                                if PlayersList.count > num - 1 {
                                    Text(PlayersList[num - 1].name)
                                        .customTextStroke()
                                        .font(.system(size: 12))
                                        .bold()
                                        .italic()
                                        .padding(.leading, 9)
                                }
                                Spacer()
                                Text(PlayersList.count > num - 1 ? String(PlayersList[num - 1].score) : "-")
                                    .font(.system(size: 21))
                                    .customTextStroke(width: 1.5)
                                    .bold()
                                    .italic()
                            }
                            .listRowBackground(RandomGradientView())
                    }
                    }
                    .allowsHitTesting(false)
                    .frame(width: self.idiom == .pad ? deviceWidth / 1.5 : deviceWidth, height: 3400, alignment: .center)
                    .scrollContentBackground(.hidden)
                }
            }
        }
        .refreshable {
            Task{
                await gameCenter.loadLeaderboard()
            }
        }
    }
    
    func openSettings() {
        if let url = URL(string: "App-Prefs:root=GameCenter") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}



#Preview {
    GameCenterLeaderboardView()
}
