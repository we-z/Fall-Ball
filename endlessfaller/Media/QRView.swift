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
                .scaleEffect(2.1)
                .offset(y: -210)
            Text("FALL BALL")
                .bold()
                .italic()
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                .scaleEffect(2.1)
                .offset(y: 210)
            Image("fallballQR")
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(30)

        }
        .ignoresSafeArea()
    }
}

struct QRView_Previews: PreviewProvider {
    static var previews: some View {
        QRView()
    }
}
