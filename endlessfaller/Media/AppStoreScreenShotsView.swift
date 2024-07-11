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
                .scaleEffect(1.9)
                .offset(y: -90)
            VStack{
                Spacer()
                HStack{
                    WizardBall()
                        .scaleEffect(2.1)
                        .padding(30)
                    Spacer()
                    NinjaBallView()
                        .scaleEffect(2.1)
                        .padding(30)
                }
                .frame(width: deviceWidth/1.2, height: 500)
                
                
                HStack{
                    UnicornView()
                        .scaleEffect(2.1)
                        .padding(30)
                    Spacer()
                    AirBallView()
                        .scaleEffect(2.1)
                        .padding(30)
                }
                .frame(width: deviceWidth/1.2, height: 500)
                Spacer()
                HStack(spacing: 30){
                    SouthKoreaView()
                    AmericaView()
                    FallBallLaughBall()
                    LGBTQFlagView()
                    ChinaView()
                }
                .scaleEffect(2.1)
            }
            .offset(y: -50)
            VStack{
                Text("Fall Ball")
                    .font(.system(size: 120))
                    .bold()
                    .italic()
                    .customTextStroke(width: 4)
                    
                DollarsignBallView()
                    .scaleEffect(9)
                    .padding(180)
                VStack{
                    VStack{
                        Text("Swipe up \nto play!")
                            .italic()
                            .multilineTextAlignment(.center)
                            .padding()
                        Image(systemName: "arrow.up")
                    }
                    .bold()
                    .font(.system(size: 60))
                    SwipeUpHand()
                        .offset(x: 60, y:60)
                }
                .frame(width: 300, height: 450)
                .customTextStroke(width: 4)
                .scaleEffect(0.75)
                .offset(y: -90)
            }
            .offset(y:30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AppStoreScreenShotsView()
}
