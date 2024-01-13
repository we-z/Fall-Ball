//
//  LandingPageView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 1/12/24.
//

import SwiftUI

struct LandingPageView: View {
    var body: some View {
        VStack{
            Text("Swipe up \nto play!")
                .italic()
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding()
            Image(systemName: "arrow.up")
                .foregroundColor(.black)
        }
        .animatedOffset(speed: 1)
        .bold()
        .font(.largeTitle)
        .scaleEffect(1.5)
    }
}

#Preview {
    LandingPageView()
}
