//
//  TitleView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/3/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 0.6), endPoint: UnitPoint(x: 0.6, y: 0.2))
            RotatingSunView()
            VStack(spacing: 60){
                HStack(spacing: 21){
                    WizardBall()
                    ShockedBall()
                    UnicornView()
                    EvilBall()
                }
                .scaleEffect(1.5)
                HStack(spacing: 36){
                    VStack(spacing: 18){
                        ChinaView()
                        AirBallView()
                    }
                    .scaleEffect(1.5)
                    Text("Fall Ball")
                        .bold()
                        .font(.system(size: 50))
                        .italic()
                        .customTextStroke(width: 2.1)
                    VStack(spacing: 18){
                        KaiView()
                        AmericaView()
                    }
                    .scaleEffect(1.5)
                }
                HStack(spacing: 21){
                    DollarsignBallView()
                    IceSpiceView()
                    MortyView()
                    OnepieceView()
                }
                .scaleEffect(1.5)
                    
            }
        }
        .ignoresSafeArea()
        
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
