//
//  QRView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/2/23.
//

import SwiftUI

struct QRView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 0.6), endPoint: UnitPoint(x: 0.6, y: 0.2))
            RotatingSunView()
            VStack{
                Text("Download Fall Ball!")
                    .bold()
                    .italic()
                    .font(.system(size: 33))
                    .customTextStroke(width: 1.5)
                    .offset(y:18)
                    .scaleEffect(1.2)
                HStack {
                    VStack(spacing: 30){
                        DollarsignBallView()
                        ShockedBall()
                    }
                    .scaleEffect(1.2)
                    ZStack{
                        Rectangle()
                            .frame(width:221, height: 221)
                        Image("fallballQR")
                            .resizable()
                            .frame(width: 210, height: 210)
                            .cornerRadius(30)
                    }
                    .cornerRadius(36)
                    .scaleEffect(0.9)
                    VStack(spacing: 30){
                        WizardBall()
                        IceSpiceView()
                    }
                    .scaleEffect(1.2)
                }
                HStack(spacing: 30) {
                    KaiView()
                    HeartEyeBallView()
                    EvilBall()
                    MortyView()
                }
                .scaleEffect(1.2)
            }
        }
        .ignoresSafeArea()
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
