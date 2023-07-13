//
//  ContentView.swift
//  endlessfaller
//
//  Created by Wheezy Salem on 7/12/23.
//

import SwiftUI
import VTabView

struct ContentView: View {
    
    @State var score: Int = 0
    @State var currentIndex: Int = 0
    
    let colors: [Color] = (1...1000).map { _ in
        Color(red: .random(in: 0.2...0.9), green: .random(in: 0.2...0.9), blue: .random(in: 0.2...0.9))
    }
    
    var body: some View {
        ScrollView {
            ZStack{
                VTabView(selection: $currentIndex) {
                    ForEach(colors.indices, id: \.self) { index in
                        Rectangle()
                            .fill(colors[index])
                    }
                }
                .frame(
                    width: UIScreen.main.bounds.width,
                    height: UIScreen.main.bounds.height
                )
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                VStack{
                    HStack{
                        Text(String(score))
                            .font(.system(size: 45))
                            .bold()
                            .padding(36)
                            .padding(.top, 30)
                        Spacer()
                    }
                    Spacer()
                }
                VStack{
                    Circle()
                        .frame(width: 45)
                        .colorInvert()
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onChange(of: currentIndex) { newValue in
            score = newValue
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
