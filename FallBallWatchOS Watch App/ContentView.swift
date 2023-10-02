//
//  ContentView.swift
//  FallBallWatchOS Watch App
//
//  Created by Wheezy Salem on 9/24/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.white
            VStack{
                Text("Swipe up\nto play!")
                    .bold()
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                Image(systemName: "arrow.up")
                    .foregroundColor(.black)
            }
            .font(.title)
                
        }
        .padding()
        .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
}
