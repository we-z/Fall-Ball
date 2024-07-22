//
//  HomeButtonsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import SwiftUI
import GroupActivities
import GameKit

let hapticGenerator = UINotificationFeedbackGenerator()

struct HomeButtonsView: View {
    @StateObject var groupStateObserver = GroupStateObserver()
    @State var isActivitySharingSheetPresented = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State private var isGearExpanded = false
    @State private var gearRotationDegrees = 0.0
    @State var whiteCircleOffset = -30.0
    @State var showCharactersMenu = false
    @State var showGameMode = false
    @State var showLeaderBoard = false
    @State var showCurrencyPage = false
    @StateObject var userPersistedData = UserPersistedData()
    @ObservedObject var gameCenter = GameCenter.shared
    var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let currentCharacter = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) ?? appModel.characters.first(where: { $0.characterID == "io.endlessfall.shocked"})
        ZStack{
            VStack{
                Text(" ")
            }
            .frame(width: deviceWidth, height: deviceHeight)
            .background(.white.opacity( showGameMode ? 0.6 : 0))
            .background(.gray.opacity( isGearExpanded ? 0.0001 : 0))
            .onTapGesture {
                impactHeavy.impactOccurred()
                withAnimation {
                    showGameMode = false
                    isGearExpanded = false
                }
            }
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let threshold: CGFloat = 50 // Adjust this threshold as needed
                        if value.translation.width > threshold || value.translation.width < -threshold {
                            // Swipe detected, perform the swipe action here
                            
                            withAnimation {
                                showGameMode = false
                                isGearExpanded = false
                            }
                        } else {
                            // Tap detected, perform the tap action here
                            withAnimation {
                                showGameMode = false
                                isGearExpanded = false
                            }
                        }
                    }
            )
            VStack{
                HStack{
                    Button {
                        showCurrencyPage = true
                    } label: {
                        HStack{
                            BoinsView()
                            Text(String(userPersistedData.boinBalance))                                .bold()
                                .italic()
                                .customTextStroke(width:2.1)
                                .font(.system(size: 30))
                        }
                        .padding(.horizontal, 21)
                        .padding(.vertical, 6)
                        .frame(height: 70)
                        .background{
                            Color.yellow
                        }
                        .cornerRadius(50)
                        .overlay{
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.black, lineWidth: 4)
                                .padding(1)
                        }
                        .padding()
                    }
                    .buttonStyle(.roundedAndShadow6)
                    .padding(.leading, 6)
                    Spacer()
                    Button{
                        self.userPersistedData.strategyModeEnabled.toggle()
                    } label: {
                        ZStack{
                            Capsule()
                                .frame(width: 130, height: 72)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                                .padding(.horizontal)
                            Capsule()
                                .frame(width: 123, height: 64)
                            //                            .foregroundColor(.white.opacity(0.75))
                                .foregroundColor(self.userPersistedData.strategyModeEnabled ? .yellow : .red)
                                .clipShape(Capsule())
                                .padding(.horizontal)
                            Circle()
                                .frame(width: 53)
                                .foregroundColor(.white)
                                .customTextStroke(width: 1.5)
                                .offset(x: whiteCircleOffset)
                            // Button 1
                            HStack(spacing:15){
                                Text("🏎️") // Replace with your image
                                    .font(.system(size: 40))
                                    .customTextStroke()
                                    .offset(y: -9)
                                
                                Text("🤔") // Replace with your image
                                    .font(.system(size: 40))
                                    .customTextStroke()
                            }
                        }
                    }
                }
                .padding(.top, idiom == .pad || UIDevice.isOldDevice ? 15 : 45)
                Spacer()
                ZStack{
                    HStack{
                        ZStack {
                            ZStack {
                                
                                // Button 3
                                Button(action: {
                                    audioController.mute.toggle()
                                }) {
                                    Image(systemName: audioController.mute ? "speaker.slash.fill" : "speaker.wave.2.fill") // Replace with your image
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 60, height: 60)
                                        .foregroundColor(.teal)
                                        .customTextStroke()
                                        .padding(.leading, 30)
                                }
                                .buttonStyle(.roundedAndShadow3)
                                .onChange(of: audioController.mute) { newSetting in
                                    audioController.setAllAudioVolume()
                                }
                            }
                            
                        }

                        Spacer()
                        Button {
                            showCharactersMenu = true
                        } label: {
                            ZStack{
                                AnyView(currentCharacter!.character)
                            }
                            .padding(30)
                            .overlay{
                                if userPersistedData.selectedHat != "nohat" {
                                    AnyView(hat!.hat)
                                        .scaleEffect(0.69)
                                        .frame(maxHeight: 30)
                                }
                            }
                            .scaleEffect(1.4)
                        }
                        .buttonStyle(.roundedAndShadow3)
                    }
                    Button {
                        showLeaderBoard = true
                    } label: {
                        PodiumView()
                            .foregroundColor(.black)
                            .padding(36)
                            .scaleEffect(1.2)
                            .offset(x:-3)
                    }
                    .buttonStyle(.roundedAndShadow3)
                }
            }
            if showGameMode {
                ZStack{
                    RandomGradientView()
                    RotatingSunView()
                        .frame(width: 300, height: 300)
                    VStack{
                        Spacer()
                        Text("Game Mode:")
                            .font(.system(size: 45))
                            .customTextStroke(width: 2)
                            .italic()
                            .bold()
                        Spacer()
                        Text(self.userPersistedData.strategyModeEnabled ? "Strategy 🤔" : "Speed 🏎️ 💨")
                            .font(.system(size: 39))
                            .customTextStroke(width: 2)
                            .italic()
                            .bold()
                        Spacer()
                        Text(self.userPersistedData.strategyModeEnabled ? "Time your swipes\nThink fast!" : "Swipe up as fast\nas you can!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 30))
                            .customTextStroke(width: 2)
                            .italic()
                            .bold()
                        Spacer()
                    }
                }
                .cornerRadius(30)
                .frame(width: 300, height: 300)
                .customTextStroke(width: 3)
                .onOpenURL { url in
                    if url.scheme == "FallBallWidget" && url.host == "open" {
                        showLeaderBoard = true
                    }
                }
            }
            
        }
        .ignoresSafeArea()
        .sheet(isPresented: self.$showCharactersMenu){
            CharactersMenuView()
        }
        .sheet(isPresented: self.$showLeaderBoard){
            GameCenterLeaderboardView()
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
        .onAppear(){
            if self.userPersistedData.strategyModeEnabled {
                whiteCircleOffset = 30
            }
        }
        .onChange(of: self.userPersistedData.strategyModeEnabled){ newValue in
            impactHeavy.impactOccurred()
            if newValue {
                withAnimation(){
                    whiteCircleOffset = 30
                }
            } else {
                withAnimation(){
                    whiteCircleOffset = -30
                }
            }
            if showGameMode == false {
                withAnimation(){
                    showGameMode = true
                }
            } else {
                withAnimation(){
                    showGameMode = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(){
                        showGameMode = true
                    }
                }
            }
        }
    }
}

#Preview {
    HomeButtonsView()
}
