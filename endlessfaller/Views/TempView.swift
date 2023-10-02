//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import VTabView
import QuartzCore


struct TempView: View {
    let colors: [Color] = [.red, .green, .blue, .orange, .indigo, .purple]
    @State private var selectedIndex: Int?
    @State var backgroundColor = Color.purple
    @State var selectedLeaderboard = 0

    var body: some View {
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
                                    .opacity(selectedLeaderboard == 0 ? 1 : 0.3)
                                    .padding(.leading)
                            }
                            Button {
                                withAnimation{
                                    self.selectedLeaderboard = 1
                                }
                            } label: {
                                
                                Text("ALL TIME")
                                    .opacity(selectedLeaderboard == 1 ? 1 : 0.3)
                                    .padding(.leading)
                            }
                        }
                        .foregroundColor(.white)
                        .font(.title3)
                        .bold()
                        .italic()
                        .padding(.top, 90)
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
                                    ForEach(4...50, id: \.self) { num in
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
                                .frame(width: g.size.width, height: 3300, alignment: .center)
                                .scrollContentBackground(.hidden)
                            }
                            .tag(1)
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    func height(index: Int) -> CGFloat {
        return selectedIndex == index ? 120 : 100
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
