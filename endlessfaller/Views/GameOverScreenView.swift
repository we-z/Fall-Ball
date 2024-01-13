//
//  GameOverScreenView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/12/24.
//

import SwiftUI

struct GameOverScreenView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var plaqueIsPressed = false
    @State var showPlaqueShare = false
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == appModel.selectedHat})
        VStack{
            Spacer()
            Text("Game Over!")
                .italic()
                .bold()
                .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.08))
                .scaleEffect(1.8)
                .padding(.bottom, deviceHeight * 0.04)
            ZStack{
                HStack{
                    VStack(alignment: .trailing){
                        Spacer()
                            .frame(maxHeight: 10)
                        HStack{
                            ZStack{
                                Text("Ball:")
                                    .font(.title)
                                    .bold()
                                    .italic()
                                    .foregroundColor(appModel.selectedHat == "nohat" ? .black : .clear)
                                    .padding(.leading, 15)
                                    .offset(x: 30)
                            }
                            Spacer()
                                .frame(maxWidth: 110)
                            Text("Score:")
                                .foregroundColor(.black)
                                .bold()
                                .italic()
                        }
                        Text(String(appModel.currentScore))
                            .bold()
                            .italic()
                            .offset(y: 6)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        Spacer()
                            .frame(maxHeight: 15)
                        Text("Best:")
                            .foregroundColor(.black)
                            .bold()
                            .italic()
                        Text(String(appModel.bestScore))
                            .bold()
                            .italic()
                            .offset(y: 6)
                            .foregroundColor(.black)
                            .font(.largeTitle)
                        Spacer()
                            .frame(maxHeight: 10)
                    }
                    .padding(.trailing, 30)
                    .padding()
                    .font(.title)
                }
                if let character = appModel.characters.first(where: { $0.characterID == appModel.playedCharacter}) {
                    ZStack{
                        AnyView(character.character)
                            .scaleEffect(1.5)
                        if appModel.selectedHat != "nohat" {
                            AnyView(hat!.hat)
                        }
                    }
                    .scaleEffect(1.5)
                    .offset(x: -70, y: appModel.selectedHat == "nohat" ? 18 : 30)
                }
            }
            .background{
                ZStack{
                    Rectangle()
                        .foregroundColor(.yellow)
                        .cornerRadius(30)
                        .shadow(color: .black, radius: 0.1, x: plaqueIsPressed ? 0 : -9, y: plaqueIsPressed ? 0 : 9)
                        .padding(.horizontal,9)
                    VStack{
                        Spacer()
                        HStack{
                            Image(systemName: "square.and.arrow.up")
                                .bold()
                                .font(.title2)
                                .padding(15)
                                .padding(.horizontal, 12)
                            Spacer()
                        }
                    }
                }
                
            }
            .offset(x: plaqueIsPressed ? -9 : 0, y: plaqueIsPressed ? 9 : 0)
            .pressEvents {
                // On press
                withAnimation(.easeInOut(duration: 0.1)) {
                    plaqueIsPressed = true
                }
            } onRelease: {
                withAnimation {
                    plaqueIsPressed = false
                    showPlaqueShare = true
                }
            }
            ZStack{
                VStack{
                    Text("Swipe up to \nplay again!")
                        .italic()
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .padding(.top, deviceHeight * 0.06)
                        .padding()
                    Image(systemName: "arrow.up")
                        .foregroundColor(.black)
                    //.shadow(color: .black, radius: 3)
                }
                .bold()
                .foregroundColor(.black)
                .font(idiom == .pad ? .largeTitle : .system(size: deviceWidth * 0.1))
                
                SwipeUpHand()
                    .scaleEffect(0.7)
                    .offset(x: 30, y:130)
            }
            .animatedOffset(speed: 1)
            Spacer()
        }
        .sheet(isPresented: self.$showPlaqueShare){
            PlayersPlaqueView()
                .presentationDetents([.height(450)])
        }
    }
}

#Preview {
    GameOverScreenView()
}
