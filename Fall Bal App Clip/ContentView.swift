//
//  ContentView.swift
//  Fall Ball App Clip
//
//  Created by Wheezy Salem on 1/14/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "arrow.up")
                .imageScale(.large)
                .padding()
                .padding(.top, 69)
            Text("Download Fall Ball!")
                .italic()
            Spacer()
        }
        .font(.largeTitle)
        .bold()
        .foregroundStyle(.black)
        .padding()
    }
}

#Preview {
    ContentView()
}
