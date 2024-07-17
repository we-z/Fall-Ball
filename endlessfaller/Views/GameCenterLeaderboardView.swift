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
    @ObservedObject private var model = AppModel.sharedAppModel
    @ObservedObject var gameCenter = GameCenter.shared
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var localPlayer = GKLocalPlayer.local
    @State var selectedLeaderboard = 0
    @State var todayLeaderboardSelected = true
    @State var capsuleOffset = -45.0
    @State var capsuleWidth = 108.0
    
    
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
                        .customTextStroke(width: 2.3)
                        .offset(y: 6)
                }
                VStack{
                    //if playersList.isEmpty{
                        ZStack{
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
                                            
                                            ZStack{
                                                ScrollView(showsIndicators: false) {
                                                    LazyVStack {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
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
                                                                    if allTimePlayersList[2].currentPlayerAlias == localPlayer.alias {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
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
                                                                    if allTimePlayersList[0].currentPlayerAlias == localPlayer.alias {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
                                                                        .padding(.horizontal)
                                                                    Text(String(allTimePlayersList[1].score))
                                                                        .customTextStroke(width: 1.5)
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
                                                                    if allTimePlayersList[1].currentPlayerAlias == localPlayer.alias {
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
                                                        LazyVStack {
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
                                                    }
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
                                            .tag(0)
                                            ZStack{
                                                ScrollView(showsIndicators: false) {
//                                                    Text(formatTimeDuration(timeLeft))
//                                                        .foregroundColor(.white)
//                                                        .bold()
//                                                        .italic()
                                                    LazyVStack {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
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
                                                                    if todaysPlayersList[2].currentPlayerAlias == localPlayer.alias {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
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
                                                                    if todaysPlayersList[0].currentPlayerAlias == localPlayer.alias {
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
                                                                                    .offset(y:3)
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
                                                                        .customShadow(radius: 0.1, width: 0.6)
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
                                                                    if todaysPlayersList[1].currentPlayerAlias == localPlayer.alias {
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
                                                                .offset(y:270)
                                                        }
                                                        LazyVStack {
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
                                                                                }
                                                                                
                                                                            }
                                                                            .offset(x: 80)
                                                                            Spacer()
                                                                            Text(todaysPlayersList.count > num - 1 ? String(todaysPlayersList[num - 1].score) : "-")
                                                                                .customTextStroke()
                                                                                .bold()
                                                                                .italic()
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
                                                    }
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
                                            .tag(1)
                                        }
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    }
                                }
                        }
                        .ignoresSafeArea()
                }
            }
            if allTimePlayersList.isEmpty {
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
            gameCenter.authenticateUser()
            Task{
                await gameCenter.loadLeaderboard()
            }
        }
        .onChange(of: gameCenter.allTimePlayersList) { newList in
            if let image = renderAllTimePodiumView() {
                saveImageToDisk(image: image, fileName: "allTimePodium.png")
            }
        }
    }
    
    @Environment(\.displayScale) var displayScale
    
    @MainActor
    private func renderAllTimePodiumView() -> UIImage?{
        
        let renderer = ImageRenderer(content: allTimePodiumView())

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    private func saveImageToDisk(image: UIImage, fileName: String) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.FallBallGroup") else {
            print("Error: Could not find container URL for the app group.")
            return
        }
        
        let url = containerURL.appendingPathComponent(fileName)
        
        if let data = image.pngData() {
            do {
                try data.write(to: url)
                print("Image saved successfully.")
                WidgetCenter.shared.reloadAllTimelines()
            } catch {
                print("Error saving image: \(error)")
            }
        } else {
            print("Error: Could not convert image to PNG data.")
        }
    }

    
    func allTimePodiumView () -> some View {
        let allTimePlayersList = gameCenter.allTimePlayersList
        return ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0))
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: 180)
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
                                        .offset(y:3)
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
                            .customShadow(radius: 0.1, width: 0.6)
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
                        if allTimePlayersList[2].currentPlayerAlias == localPlayer.alias {
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
                                        .offset(y:3)
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
                            .customShadow(radius: 0.1, width: 0.6)
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
                        if allTimePlayersList[0].currentPlayerAlias == localPlayer.alias {
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
                                        .offset(y:3)
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
                            .customShadow(radius: 0.1, width: 0.6)
                            .padding(.horizontal)
                        Text(String(allTimePlayersList[1].score))
                            .customTextStroke(width: 1.5)
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
                        if allTimePlayersList[1].currentPlayerAlias == localPlayer.alias {
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
            .scaleEffect(0.7)
            .offset(y: -45)
        }
        .frame(width: 330, height: 330)
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
