//
//  AppStoreScreenShotsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/21/24.
//

import SwiftUI

struct AppStoreScreenShotsView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 0.6), endPoint: UnitPoint(x: 0.6, y: 0.2))
                .ignoresSafeArea()
            RotatingSunView()
                .offset(y: -90)
            VStack{
                Text("Fall Ball")
                    .font(.system(size: 100))
                    .bold()
                    .italic()
                    .customTextStroke(width: 3.3)
                    
                DollarsignBallView()
                    .scaleEffect(7)
                    .padding(90)
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
                        .offset(x: 60, y:60)
                }
                .frame(width: 300, height: 400)
                .customTextStroke(width: 2.7)
            }
            .offset(y:30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AppStoreScreenShotsView()
}
