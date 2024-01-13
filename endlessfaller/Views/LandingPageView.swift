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
            VStack{
                Text("Swipe up \nto play!")
                    .italic()
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .padding()
                Image(systemName: "arrow.up")
                    .foregroundColor(.black)
            }
            .bold()
            .font(.largeTitle)
            .scaleEffect(1.5)
            SwipeUpHand()
                .scaleEffect(0.75)
                .offset(x: 40, y:40)
        }
        .animatedOffset(speed: 1)
    }
}

#Preview {
    LandingPageView()
}
