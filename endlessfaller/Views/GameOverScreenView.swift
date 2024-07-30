//
//  GameOverScreenView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/12/24.
//

import SwiftUI
import GameKit

struct GameOverScreenView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @StateObject var audioController = AudioManager.sharedAudioManager
    @State private var sheetPresented : Bool = false
    @Environment(\.displayScale) var displayScale
    @State var showPlaqueShare = false
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @StateObject var userPersistedData = UserPersistedData()
    
    @MainActor
    private func render() -> UIImage?{
        
        let renderer = ImageRenderer(content: plaqueView())

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    private func plaqueView () -> some View {
        
        ZStack{
            Rectangle()
                .overlay(RandomGradientView())
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: -45)
            VStack{
                Text("I Play Fall Ball As:")
                    .customTextStroke(width: 1.5)
                    .font(.system(size: 21))
                    .bold()
                    .italic()
                if let character = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) {
                    let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
                    let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag})
                    ZStack{
                        if userPersistedData.selectedBag != "nobag" {
                            AnyView(bag!.bag)
                                .frame(maxWidth: 180, maxHeight: 60)
                        }
                        AnyView(character.character)
                            .scaleEffect(1.5)
                        if userPersistedData.selectedHat != "nohat" {
                            AnyView(hat!.hat)
                                .frame(maxWidth: 60, maxHeight: 60)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 39)
                    .scaleEffect(1.2)
                    .offset(y:20)
                }
                
                Text(GKLocalPlayer.local.isAuthenticated ? GKLocalPlayer.local.displayName : "Unknown Player")
                    .customShadow(width: 1)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
                    .bold()
                    .italic()
                    .font(.system(size: 30))
                Text("Beat My Top Score: \(userPersistedData.bestScore)")
                    .customTextStroke(width: 1.5)
                    .font(.system(size: 21))
                    .bold()
                    .italic()
                    .padding(12)
                    .background(.black.opacity(0.1))
                    .cornerRadius(18)
            }
        }
        .frame(width: 330, height: 330)
    }
    
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
                    .font(idiom == .pad ? .largeTitle : .system(size: 30))
                    .scaleEffect(1.8)
                    .padding(.bottom, deviceHeight * 0.04)
                    .allowsHitTesting(false)
                Button {
                    self.sheetPresented = true
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
                                                .font(.system(size: 27))
                                                .bold()
                                                .italic()
                                                .customTextStroke(width: 2.1)
                                                .padding(.leading, 15)
                                                .offset(x: 30)
                                        } else {
                                            Text("Ball:")
                                                .font(.system(size: 27))
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
                                        .customTextStroke(width: 2.1)
                                        .bold()
                                        .italic()
                                }
                                Text(String(appModel.currentScore))
                                    .bold()
                                    .italic()
                                    .offset(y: 6)
                                    .customTextStroke(width: 2.1)
                                    .font(.system(size: 30))
                                Spacer()
                                    .frame(maxHeight: 15)
                                Text("Best:")
                                    .customTextStroke(width: 2.1)
                                    .bold()
                                    .italic()
                                Text(String(userPersistedData.bestScore))
                                    .bold()
                                    .italic()
                                    .offset(y: 6)
                                    .customTextStroke(width: 2.1)
                                    .font(.system(size: 30))
                                Spacer()
                                    .frame(maxHeight: 10)
                            }
                            .padding(.trailing, 30)
                            .padding()
                            .font(.system(size: 30))
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
                                .overlay{
                                    RoundedRectangle(cornerRadius: 30)
                                        .stroke(Color.black, lineWidth: 3)
                                        .padding(1)
                                }
                                .padding(.horizontal,9)
                                
                            VStack{
                                Spacer()
                                HStack{
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.black)
                                        .bold()
                                        .font(.system(size: 18))
                                        .padding(15)
                                        .padding(.horizontal, 12)
                                    Spacer()
                                }
                            }
                        }
                        
                    }
                }
                .buttonStyle(.roundedAndShadow9)
                if !userPersistedData.hasSharedFallBall {
                    HStack {
                        Text("⬆️ Share and earn 5 Boins!")
                            .bold()
                            .italic()
                            .font(.system(size: 21))
                            .customTextStroke(width: 1.5)
                        BoinsView()
                    }
                    .offset(y: 21)
                }
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
                    .font(idiom == .pad ? .system(size: 30) : .system(size: deviceWidth * 0.1))
                }
                
                .animatedOffset(speed: 1)
                .frame(height: 300)
                .customTextStroke(width: 2.4)
                Spacer()
            }
            .offset(y: userPersistedData.hasSharedFallBall ? 0 : 15)
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
        .sheet(isPresented: $sheetPresented, content: {
                
            if let data = render() {
       
                ShareView(activityItems: [data, "Play Fall Ball with me!\n\nhttps://apple.co/48036v5"])
           
            }
            
        })
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                appModel.showNewBestScore = false
            }
        }
        
    }
}
