//
//  ContentView.swift
//  FallBallWatchOS Watch App
//
//  Created by Wheezy Salem on 9/24/23.
//

import SwiftUI

let levels = 1000

struct ContentView: View {
    @State var screenHeight = WKInterfaceDevice.current().screenBounds.size.height
    @State var colors: [Color] = (1...levels).map { _ in
        Color(red: .random(in: 0.1...1), green: .random(in: 0.1...1), blue: .random(in: 0.1...1))
    }
    @State var score = -1
    
    
    var body: some View {
        ZStack{
            ScrollView {
                VStack(spacing: 0){
                    ZStack{
                        colors[500]
                        VStack{
                            Text("Swipe up\nto play!")
                                .bold()
                                .italic()
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .padding()
                            Image(systemName: "arrow.up")
                                .foregroundColor(.black)
                                .bold()
                        }
                        .font(.title2)
                    }
                    .frame(height: screenHeight)
                    ForEach(colors.indices, id: \.self) { index in
                        ZStack {
                            colors[index]
                        }
                        .frame(height: screenHeight)
                        .onAppear {
                            self.score = index
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.paging)
            
            
            VStack{
                HStack{
                    Text("\(self.score)")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()
                        .italic()
                        .padding(21)
                        .allowsHitTesting(false)
                    Spacer()
                }
                Spacer()
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
