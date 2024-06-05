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
    @State private var gearRotationDegrees = 0.0
    @State var whiteCircleOffset = -30.0
    @State var showCharactersMenu = false
    @State var showGameMode = false
    @State var showLeaderBoard = false
    @State var showCurrencyPage = false
    @StateObject var userPersistedData = UserPersistedData()
    var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let currentCharacter = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) ?? appModel.characters.first(where: { $0.characterID == "io.endlessfall.shocked"})
        ZStack{
            VStack{
                Text(" ")
            }
            .frame(width: deviceWidth, height: deviceHeight)
            .background(.gray.opacity( showGameMode ? 0.9 : 0))
            .background(.gray.opacity( isGearExpanded ? 0.0001 : 0))
            .onTapGesture {
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
                    ZStack{
                        Capsule()
                            .frame(width: 129, height: 69)
                            .foregroundColor(.black)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                        Capsule()
                            .frame(width: 120, height: 60)
                            .foregroundColor(.gray)
                            .clipShape(Capsule())
                            .padding(.horizontal)
                        Circle()
                            .frame(width: 53)
                            .foregroundColor(.white)
                            .offset(x: whiteCircleOffset)
                        // Button 1
                        HStack(spacing:15){
                            Button(action: {
                                withAnimation() {
                                    whiteCircleOffset = -30
                                }
                                self.userPersistedData.strategyModeEnabled = false
                            }) {
                                Text("🏎️") // Replace with your image
                                    .font(.system(size: 40))
                                    .customTextStroke()
                                    .offset(y: -9)
                            }
                            
                            // Button 2
                            Button(action: {
                                withAnimation() {
                                    whiteCircleOffset = 30
                                }
                                self.userPersistedData.strategyModeEnabled = true
                            }) {
                                Text("🤔") // Replace with your image
                                    .font(.system(size: 40))
                                    .customTextStroke()
                            }
                        }
                    }
                    Spacer()
                    Button {
                        showCurrencyPage = true
                    } label: {
                        HStack{
                            BoinsView()
                            Text(String(userPersistedData.boinBalance))
                                .bold()
                                .italic()
                                .customTextStroke(width:2.1)
                                .font(.largeTitle)
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
                            .offset(y: -6)
                            .opacity(isGearExpanded ? 1 : 0)
                            
                            // Gear Button
                            Button(action: {
                                withAnimation {
                                    self.gearRotationDegrees += 45
                                    self.isGearExpanded.toggle()
                                    self.showGameMode = false
                                }
                                hapticGenerator.notificationOccurred(.error)
                            }) {
                                Image(systemName: "gearshape.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 45, height: 45)
                                    .padding(36)
                                    .foregroundColor(.white.opacity(0.8))
                                    .rotationEffect(.degrees(gearRotationDegrees))
                            }
                        }
                        .background {
                            Capsule()
                                .strokeBorder(Color.black,lineWidth: 3)
                                .frame(width: 69, height: isGearExpanded ? 139 : 69)
                                .background(.black)
                                .clipShape(Capsule())
                                .offset(y: isGearExpanded ? -36 : 0)
                        }
                        .onDisappear{
                            isGearExpanded = false
                            showGameMode = false
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
            if showGameMode {
                ZStack{
                    RandomGradientView()
                    RotatingSunView()
                        .frame(width: 210, height: 210)
                    VStack{
                        Spacer()
                        Text("Game Mode:")
                            .font(.system(size: 30))
                            .customTextStroke(width: 1.5)
                            .italic()
                            .bold()
                        Spacer()
                        Text(self.userPersistedData.strategyModeEnabled ? "Strategy 🤔" : "Speed 🏎️ 💨")
                            .font(.system(size: 27))
                            .customTextStroke(width: 1.5)
                            .italic()
                            .bold()
                        Spacer()
                        Text(self.userPersistedData.strategyModeEnabled ? "Time your swipes\nThink fast!" : "Swipe up as fast\nas you can!")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 21))
                            .customTextStroke(width: 1.5)
                            .italic()
                            .bold()
                        Spacer()
                    }
                }
                .cornerRadius(30)
                
                .frame(width: 210, height: 210)
                .customTextStroke(width: 3)
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
        .onAppear(){
            if self.userPersistedData.strategyModeEnabled {
                whiteCircleOffset = 30
            }
        }
        .onChange(of: self.userPersistedData.strategyModeEnabled){ newValue in
            withAnimation(){
                showGameMode = true
            }
        }
    }
}

#Preview {
    HomeButtonsView()
}
