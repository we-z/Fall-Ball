//
//  HUDView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/10/24.
//

import SwiftUI
import GroupActivities

struct HUDView: View {
    @StateObject var groupStateObserver = GroupStateObserver()
    @State var isActivitySharingSheetPresented = false
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject private var audioController = AudioManager.sharedAudioManager
    @State private var isGearExpanded = false
    @State var showGameModesAlert = false
    @State private var gearRotationDegrees = 0.0
    @State var ballButtonIsPressed = false
    @State var showCharactersMenu = false
    @State var showLeaderBoard = false
    @State var currencyButtonIsPressed = false
    @State var showCurrencyPage = false
    @StateObject var userPersistedData = UserPersistedData()
    
    let gearHaptic = UINotificationFeedbackGenerator()
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        VStack{
            HStack{
                Spacer()
                HStack{
                    BoinsView()
                    Text(String(userPersistedData.boinBalance))
                        .bold()
                        .italic()
                        .foregroundColor(.black)
                        .font(.largeTitle)
                }
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background{
                    Color.yellow
                }
                .cornerRadius(15)
                .shadow(color: .black, radius: 0.1, x: currencyButtonIsPressed ? 0 : -6, y: currencyButtonIsPressed ? 0 : 6)
                .offset(x: currencyButtonIsPressed ? -6 : 0, y: currencyButtonIsPressed ? 6 : 0)
                .padding()
                .pressEvents {
                    // On press
                    withAnimation(.easeInOut(duration: 0.1)) {
                        currencyButtonIsPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        currencyButtonIsPressed = false
                        showCurrencyPage = true
                    }
                }
            }
            .padding(.top, 45)
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
                            }) {
                                Image(systemName: "gamecontroller.fill") // Replace with your image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .foregroundColor(.purple)
                            }
                            .offset(y: isGearExpanded ? -120 : 0)
                            .alert("Different game modes coming soon", isPresented: $showGameModesAlert) {
                                Button("OK", role: .cancel) { }
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
                        }
                        .offset(y: -15)
                        .opacity(isGearExpanded ? 1 : 0)
                        
                        // Gear Button
                        Button(action: {
                            withAnimation {
                                self.gearRotationDegrees += 45
                                self.isGearExpanded.toggle()
                            }
                            gearHaptic.notificationOccurred(.error)
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
                    ZStack{
                        if let character = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) {
                            ZStack{
                                AnyView(character.character)
                            }
                            .padding(30)
                            .overlay{
                                if userPersistedData.selectedHat != "nohat" {
                                    AnyView(hat!.hat)
                                        .scaleEffect(0.69)
                                        .frame(maxHeight: 30)
                                }
                            }
                            .scaleEffect(ballButtonIsPressed ? 1.2 : 1.4)
                        }
                    }
                    
                    .pressEvents {
                        // On press
                        withAnimation(.easeInOut(duration: 0.1)) {
                            ballButtonIsPressed = true
                        }
                    } onRelease: {
                        withAnimation {
                            ballButtonIsPressed = false
                            showCharactersMenu = true
                        }
                    }
                }
                ZStack{
                    PodiumView()
                        .foregroundColor(.black)
                        .padding(36)
                        .scaleEffect(1.2)
                        .offset(x:3)
                        .pressEvents {
                            
                        } onRelease: {
                            withAnimation {
                                showLeaderBoard = true
                            }
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
        .sheet(isPresented: $isActivitySharingSheetPresented) {
            ActivitySharingViewController(activity: SharePlayActivity())
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
    }
}

#Preview {
    HUDView()
}
