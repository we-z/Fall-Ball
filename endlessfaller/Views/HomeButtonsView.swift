//
//  HomeButtonsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import SwiftUI
import GroupActivities

let hapticGenerator = UINotificationFeedbackGenerator()

struct HomeButtonsView: View {
    @StateObject var groupStateObserver = GroupStateObserver()
    @State var isActivitySharingSheetPresented = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State private var isGearExpanded = false
    @State var showGameModesAlert = false
    @State private var gearRotationDegrees = 0.0
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var showCurrencyPage = false
    @StateObject var userPersistedData = UserPersistedData()
    var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let currentCharacter = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) ?? appModel.characters.first(where: { $0.characterID == "io.endlessfall.shocked"})
        VStack{
            HStack{
                Spacer()
                Button {
                    showCurrencyPage = true
                } label: {
                    HStack{
                        BoinsView()
                        Text(userPersistedData.infiniteBoinsUnlocked ? "∞" : String(userPersistedData.boinBalance))
                            .bold()
                            .italic()
                        
                            .customTextStroke(width:2.4)
                            .font(.largeTitle)
                            
                            .scaleEffect(userPersistedData.infiniteBoinsUnlocked ? 1.8 : 1)
                            .padding(.horizontal, userPersistedData.infiniteBoinsUnlocked ? 12 : 0)
                            .offset(y: userPersistedData.infiniteBoinsUnlocked ? -3 : 0)
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 6)
                    .background{
                        Color.yellow
                    }
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 3)
                            .padding(1)
                    }
                    .padding()
                }
                .buttonStyle(.roundedAndShadow6)
            }
            .padding(.top, idiom == .pad || UIDevice.isOldDevice ? 15 : 45)
            Spacer()
            ZStack{
                HStack{
                    ZStack {
                        ZStack {
                            // Button 1
                            Button(action: {
                                if groupStateObserver.isEligibleForGroupSession {
                                    appModel.startSharing()
                                } else {
                                    isActivitySharingSheetPresented = true
                                }
                            }) {
                                Image(systemName: "shareplay") // Replace with your image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.green)
                            }
                            .offset(y: isGearExpanded ? -180 : 0)
                            
                            // Button 2
                            Button(action: {
                                showGameModesAlert = true
                                self.userPersistedData.strategyModeEnabled.toggle()
                            }) {
                                Image(systemName: userPersistedData.strategyModeEnabled ? "brain" : "timer") // Replace with your image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.purple)
                            }
                            .offset(y: isGearExpanded ? -120 : 0)
                            .alert(userPersistedData.strategyModeEnabled ? "Strategy mode enabled ✅" : "Speed mode enabled ✅", isPresented: $showGameModesAlert) {
                                Button("Let's Go!", role: .cancel) { }
                            }
                            
                            // Button 3
                            Button(action: {
                                audioController.mute.toggle()
                            }) {
                                Image(systemName: audioController.mute ? "speaker.slash.fill" : "speaker.wave.2.fill") // Replace with your image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.teal)
                            }
                            .offset(y: isGearExpanded ? -60 : 0)
                            .onChange(of: audioController.mute) { newSetting in
                                audioController.setAllAudioVolume()
                            }
                        }
                        .offset(y: -15)
                        .opacity(isGearExpanded ? 1 : 0)
                        
                        // Gear Button
                        Button(action: {
                            withAnimation {
                                self.gearRotationDegrees += 45
                                self.isGearExpanded.toggle()
                            }
                            hapticGenerator.notificationOccurred(.error)
                        }) {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 45, height: 45)
                                .padding(36)
                                .foregroundColor(.gray)
                                .rotationEffect(.degrees(gearRotationDegrees))
                        }
                    }
                    .background {
                        Capsule()
                            .strokeBorder(Color.black,lineWidth: 3)
                            .frame(width: 66, height: isGearExpanded ? 254 : 66)
                            .background(.black)
                            .clipShape(Capsule())
                            .offset(y: isGearExpanded ? -95 : 0)
                    }
                    .onDisappear{
                        isGearExpanded = false
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
                        .offset(x:3)
                }
                .buttonStyle(.roundedAndShadow3)
            }
        }
        .ignoresSafeArea()
        .sheet(isPresented: self.$showCharactersMenu){
            CharactersMenuView()
        }
        .sheet(isPresented: self.$showLeaderBoard){
            GameCenterLeaderboardView()
        }
        .sheet(isPresented: $isActivitySharingSheetPresented) {
            ActivitySharingViewController(activity: SharePlayActivity())
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
    }
}

#Preview {
    HomeButtonsView()
}
