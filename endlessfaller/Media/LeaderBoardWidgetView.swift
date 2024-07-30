//
//  LeaderBoardWidgetView.swift
//  Fall Ball
//
//  Created by Wheezy Capowdis on 7/14/24.
//
import GameKit
import SwiftUI

struct LeaderBoardWidgetView: View {
    @Environment(\.displayScale) var displayScale
    @ObservedObject var gameCenter = GameCenter.shared
    @ObservedObject private var model = AppModel.sharedAppModel
    private var localPlayer = GKLocalPlayer.local
    
    @MainActor
    private func renderAllTimePodiumView() -> UIImage?{
        
        let renderer = ImageRenderer(content: allTimePodiumView())

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    func allTimePodiumView () -> some View {
        let allTimePlayersList = gameCenter.allTimePlayersList
        return ZStack{
            LinearGradient(gradient: Gradient(colors: [.red,.teal,.purple]), startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0))
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: 180)
            VStack{
                Text("🏆 Podium 🏆")
                    .font(.system(size: 36))
                    .bold()
                    .italic()
                    .customShadow(width: 1.5)
                    .padding(.top, 90)
                Spacer()
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
                            .font(.system(size: 30))
                            .scaleEffect(1.2)
                            .customTextStroke()
                        if allTimePlayersList.count > 2 {
                            Text(allTimePlayersList[2].name)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 21))
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
                .offset(y: -180)
            }
            .scaleEffect(0.7)
        }
        .frame(width: 330, height: 330)
    }
    var body: some View {
        allTimePodiumView()
            .cornerRadius(30)
    }
}

#Preview {
    LeaderBoardWidgetView()
}
