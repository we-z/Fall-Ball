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
            Text("Download")
                .bold()
                .italic()
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                .scaleEffect(1.5)
                .offset(y: -140)
            Text("FALL BALL")
                .bold()
                .italic()
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                .scaleEffect(1.5)
                .offset(y: 139)
            ShockedBall()
                .offset(x:106)
                .scaleEffect(1.5)
            FallBallLaughBall()
                .offset(x:-106)
                .scaleEffect(1.5)
            RotatingSunView()
            Image("fallballQR")
                .resizable()
                .frame(width: 210, height: 210)
                .cornerRadius(30)
    
            
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
