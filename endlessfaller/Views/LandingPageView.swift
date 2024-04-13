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
                    .padding()
                Image(systemName: "arrow.up")
            }
            .bold()
            .font(.largeTitle)
            .scaleEffect(1.5)
            SwipeUpHand()
                .offset(x: 40, y:40)
        }
        .frame(width: 300, height: 400)
        .animatedOffset(speed: 1)
        .customTextStroke(width: 2.7)
    }
}

#Preview {
    LandingPageView()
}
