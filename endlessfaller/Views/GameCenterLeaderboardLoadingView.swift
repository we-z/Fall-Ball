//
//  GameCenterLeaderboardLoadingView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/30/23.
//

import SwiftUI

struct GameCenterLeaderboardLoadingView: View {
    @State var backgroundColor = Color.purple
    var body: some View {

                VStack{
                    if playersList.isEmpty{
                        ZStack{
                            backgroundColor
                                .overlay(.black.opacity(0.1))
                            GeometryReader { g in
                                ZStack{
                                    backgroundColor
                                        .overlay(.black.opacity(0.5))
                                    VStack{
                                        HStack{
                                            Button {
                                                withAnimation{
                                                    self.selectedLeaderboard = 0
                                                }
                                            } label: {
                                                Text("TODAY")
                                                    .opacity(selectedLeaderboard == 0 ? 1 : 0.5)
                                                    .padding(.leading)
                                            }
                                            Button {
                                                withAnimation{
                                                    self.selectedLeaderboard = 1
                                                }
                                            } label: {
                                                
                                                Text("ALL TIME")
                                                    .opacity(selectedLeaderboard == 1 ? 1 : 0.5)
                                                    .padding(.leading)
                                            }
                                        }
                                        .foregroundColor(.white)
                                        .font(.title3)
                                        .bold()
                                        .italic()
                                        .shadow(color: .black, radius: 1, x: -3, y: 3)
                                        TabView(selection: $selectedLeaderboard){
                                            ScrollView(showsIndicators: false) {
                                                HStack{
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥈")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    .offset(y: 40)
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥇")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                                Text("👑")
                                                                    .font(.largeTitle)
                                                                    .offset(y:-50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥉")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    .offset(y: 40)
                                                }.offset(y: 20).padding(.bottom, 30)
                                                List {
                                                    ForEach(4...12, id: \.self) { num in
                                                        ZStack{
                                                            HStack{
                                                                Text("\(num)")
                                                                    .bold()
                                                                    .italic()
                                                                Spacer()
                                                                Text("-")
                                                                    .bold()
                                                                    .italic()
                                                            }
                                                            WhiteBallView()
                                                                .position(x: 60, y: 30)
                                                        }
                                                        .listRowBackground(backgroundColor.overlay(.black.opacity(0.15)))
                                                    }
                                                    
                                                }
                                                .allowsHitTesting(false)
                                                .frame(width: g.size.width, height: 700, alignment: .center)
                                                .scrollContentBackground(.hidden)
                                            }
                                            .tag(0)
                                            ScrollView(showsIndicators: false) {
                                                HStack{
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥈")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    .offset(y: 40)
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥇")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                                Text("👑")
                                                                    .font(.largeTitle)
                                                                    .offset(y:-50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    VStack{
                                                        Circle()
                                                            .foregroundColor(.white)
                                                            .padding(.horizontal)
                                                            .overlay{
                                                                Text("🥉")
                                                                    .font(.largeTitle)
                                                                    .offset(y:50)
                                                            }
                                                        
                                                        Text("-")
                                                            .font(.largeTitle)
                                                            .bold()
                                                            .italic()
                                                    }
                                                    .offset(y: 40)
                                                }.offset(y: 20).padding(.bottom, 30)
                                                List {
                                                    ForEach(4...12, id: \.self) { num in
                                                        ZStack{
                                                            HStack{
                                                                Text("\(num)")
                                                                    .bold()
                                                                    .italic()
                                                                Spacer()
                                                                Text("-")
                                                                    .bold()
                                                                    .italic()
                                                            }
                                                            WhiteBallView()
                                                                .position(x: 60, y: 30)
                                                        }
                                                        .listRowBackground(backgroundColor.overlay(.black.opacity(0.15)))
                                                    }
                                                    
                                                }
                                                .allowsHitTesting(false)
                                                .frame(width: g.size.width, height: 700, alignment: .center)
                                                .scrollContentBackground(.hidden)
                                            }
                                            .tag(1)
                                        }
                                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                                    }
                                    ProgressView()
                                        .scaleEffect(2)
                                }
                            }
                        }
                        .ignoresSafeArea()
                            
                    } else {
                        ZStack{
                            ScrollViewReader { value in
                                ScrollView(showsIndicators: false){
                                    Text(formatTimeDuration(timeLeft))
                                        .bold()
                                        .padding(.top)
                                    ForEach(Array(playersList.enumerated()), id: \.1.self) { index, player in
                                        let place = index + 1
                                        VStack{
                                            ZStack{
                                                HStack{
                                                    if place == 1 {
                                                        Text("🥇 ")
                                                            .padding(.leading)
                                                            .font(.largeTitle)
                                                            .scaleEffect(1.5)
                                                            .offset(y: -9)
                                                    } else if place == 2 {
                                                        Text("🥈 ")
                                                            .font(.largeTitle)
                                                            .padding(.leading)
                                                            .scaleEffect(1.5)
                                                            .offset(y: -9)
                                                    } else if place == 3 {
                                                        Text("🥉 ")
                                                            .font(.largeTitle)
                                                            .padding(.leading)
                                                            .scaleEffect(1.5)
                                                            .offset(y: -9)
                                                    } else {
                                                        Text(String(place) + ":")
                                                            .italic()
                                                            .bold()
                                                            .font(.title)
                                                            .foregroundColor(.black)
                                                            .frame(maxWidth: .infinity, alignment: .center)
                                                            .position(x: 33, y: 45)
                                                    }
                                                    Spacer()
                                                }
                                                .offset(x: idiom == .pad ? deviceWidth * 0.1 : deviceWidth * 0.19, y: -15)
                                                if model.characters.count > player.ballID {
                                                    let playerCharacter = model.characters[player.ballID]
                                                    AnyView(playerCharacter.character)
                                                        .padding(.horizontal)
                                                        .frame(width: 95)
                                                        .position(x: idiom == .pad ? deviceWidth * 0.1 : deviceWidth * 0.18, y: 50)
                                                        .scaleEffect(1.2)
                                                } else {
                                                    Image(systemName: "questionmark.circle")
                                                        .font(.system(size: 55))
                                                        .position(x: idiom == .pad ? deviceWidth * 0.05 : deviceWidth * 0.12, y: 50)
                                                }
                                                Text(player.name)
                                                    .bold()
                                                    .italic()
                                                    .font(.title3)
                                                    .foregroundColor(.black)
                                                    .offset(x: idiom == .pad ? deviceWidth * 0.12 : deviceWidth * 0.24, y: 21)
                                                    .frame(maxWidth: .infinity, alignment: .leading)
                                                Text(String(player.score))
                                                    .bold()
                                                    .italic()
                                                    .font(.title)
                                                    .foregroundColor(.black)
                                                    .position(x: idiom == .pad ? deviceWidth * 0.6 : deviceWidth - 70, y: 50)
                                                    .frame(maxWidth: .infinity, alignment: .center)
                                                if player.currentPlayer == localPlayer{
                                                    Text("(You)")
                                                        .bold()
                                                        .font(.title2)
                                                        .offset(y: -21)
                                                }
                                            }
                                        }
                                        .frame(height: 100)
                                        .background(.white)
                                        .cornerRadius(20)
                                        .shadow(radius: 2, y:2)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(player.currentPlayer == localPlayer ? Color.black : .clear, lineWidth: 3)
                                                .flashing()
                                        )
                                        .padding(.top, 6)
                                        .padding(.horizontal)
                                        .id(index)
                                        .onAppear{
                                            if player.currentPlayer == localPlayer {
                                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                                                    withAnimation {
                                                        value.scrollTo(index)
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    .padding(.top)
                                }
                                .refreshable {
                                    Task{
                                        await loadLeaderboard(source: 4)
                                    }
                                }
                            }
                        }
                        
                    }
                }

    }
}

#Preview {
    GameCenterLeaderboardLoadingView()
}
