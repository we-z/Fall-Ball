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
            Circle()
                .stroke(lineWidth: 6)
                .frame(width: 424)
            VStack(spacing: 240){
                Text("Download")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .customTextStroke(width: 1.5)
                    .scaleEffect(1.5)
                Text("FALL BALL")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .customTextStroke(width: 1.5)
                    .scaleEffect(1.5)
            }
            HStack(spacing: 270) {
                ShockedBall()
                    .scaleEffect(1.5)
                FallBallLaughBall()
                    .scaleEffect(1.5)
            }
            ZStack{
                Rectangle()
                    .frame(width:224, height: 224)
                Image("fallballQR")
                    .resizable()
                    .frame(width: 210, height: 210)
                    .cornerRadius(30)
            }
            .cornerRadius(39)
        }
        .mask(
            Circle()
                .frame(width: deviceWidth)
        )
        .ignoresSafeArea()
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
