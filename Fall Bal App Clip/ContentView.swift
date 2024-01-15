//
//  ContentView.swift
//  Fall Bal App Clip
//
//  Created by Wheezy Salem on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            ZStack{
                Circle()
                    .frame(width: 50)
                    .foregroundStyle(.black)
                Image(systemName: "face.smiling.inverse")
                    .foregroundStyle(.yellow)
            }
            .font(.largeTitle)
            .imageScale(.large)
            .padding()
            Text("Play Fall Ball!")
                .font(.largeTitle)
                .bold()
                .italic()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
