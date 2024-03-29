//
//  GameOverScreenView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/12/24.
//

import SwiftUI

struct GameOverScreenView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State var showPlaqueShare = false
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @StateObject var userPersistedData = UserPersistedData()
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let character = appModel.characters.first(where: { $0.characterID == appModel.playedCharacter})
        ZStack{
            VStack{
                Spacer()
                Text("Game Over!")
                    .customTextStroke(width: 1.5)
                    .italic()
                    .bold()
                    .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.08))
                    .scaleEffect(1.8)
                    .padding(.bottom, deviceHeight * 0.04)
                    .allowsHitTesting(false)
                Button {
                    showPlaqueShare = true
                } label: {
                    
                    ZStack{
                        HStack{
                            VStack(alignment: .trailing){
                                Spacer()
                                    .frame(maxHeight: 10)
                                HStack{
                                    ZStack{
                                        if userPersistedData.selectedHat == "nohat" {
                                            Text("Ball:")
                                                .font(.title)
                                                .bold()
                                                .italic()
                                                .customTextStroke(width: 1.5)
                                                .padding(.leading, 15)
                                                .offset(x: 30)
                                        } else {
                                            Text("Ball:")
                                                .font(.title)
                                                .bold()
                                                .italic()
                                                .foregroundColor(.clear)
                                                .padding(.leading, 15)
                                                .offset(x: 30)
                                        }
                                    }
                                    Spacer()
                                        .frame(maxWidth: 110)
                                    Text("Score:")
                                        .customTextStroke(width: 1.5)
                                        .bold()
                                        .italic()
                                }
                                Text(String(appModel.currentScore))
                                    .bold()
                                    .italic()
                                    .offset(y: 6)
                                    .customTextStroke(width: 1.5)
                                    .font(.largeTitle)
                                Spacer()
                                    .frame(maxHeight: 15)
                                Text("Best:")
                                    .customTextStroke(width: 1.5)
                                    .bold()
                                    .italic()
                                Text(String(userPersistedData.bestScore))
                                    .bold()
                                    .italic()
                                    .offset(y: 6)
                                    .customTextStroke(width: 1.5)
                                    .font(.largeTitle)
                                Spacer()
                                    .frame(maxHeight: 10)
                            }
                            .padding(.trailing, 30)
                            .padding()
                            .font(.title)
                        }
                        ZStack{
                            AnyView(character!.character)
                                .scaleEffect(1.5)
                            if userPersistedData.selectedHat != "nohat" {
                                AnyView(hat!.hat)
                            }
                        }
                        .scaleEffect(1.5)
                        .offset(x: -70, y: userPersistedData.selectedHat == "nohat" ? 18 : 30)
                    }
                    .background{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.yellow)
                                .cornerRadius(30)
                                .padding(.horizontal,9)
                            VStack{
                                Spacer()
                                HStack{
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.title2)
                                        .padding(15)
                                        .padding(.horizontal, 12)
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                }
                .buttonStyle(.roundedAndShadow9)
                
                ZStack{
                    VStack{
                        Text("Swipe up to \nplay again!")
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding(.bottom)
                        Image(systemName: "arrow.up")
                        //.shadow(color: .black, radius: 3)
                    }
                    .bold()
                    .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.1))
                }
                
                .animatedOffset(speed: 1)
                .frame(height: 300)
                .customTextStroke(width: 1.8)
                Spacer()
            }
            if appModel.showNewBestScore {
                ZStack{
                    NewBestScore()
                        .onAppear{
                            audioController.dingsSoundEffect.play()
                        }
                    CelebrationEffect()
                }
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appModel.showNewBestScore = false
            }
        }
        .sheet(isPresented: self.$showPlaqueShare){
            PlayersPlaqueView()
                .presentationDetents([.height(450)])
        }
        
    }
}
