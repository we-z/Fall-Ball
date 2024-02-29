//
//  NBQRView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/28/24.
//

import SwiftUI

struct NBQRView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.pink,.purple,.blue]), startPoint: UnitPoint(x: 0, y: 0.6), endPoint: UnitPoint(x: 0.6, y: 0.2))

            Text("Donate to")
                .bold()
                .italic()
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                .scaleEffect(2.1)
                .offset(y: -210)
            Text("Noisebridge")
                .bold()
                .italic()
                .font(.largeTitle)
                .foregroundColor(.white)
                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                .scaleEffect(1.8)
                .offset(y: 210)
            Image("nbqrcode")
                .resizable()
                .frame(width: 300, height: 300)
                .cornerRadius(30)

        }
        .ignoresSafeArea()
    }
}

struct NBQRView_Previews: PreviewProvider {
    static var previews: some View {
        NBQRView()
    }
}
