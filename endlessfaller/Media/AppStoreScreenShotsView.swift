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
                .offset(y:-120)
            VStack{
                Text("FALL BALL")
                    .font(.largeTitle)
                    .bold()
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                    .scaleEffect(1.5)
                ZStack{
                    Image("homescreenshot")
                        .resizable()
                        .frame(width: 230, height: 500)
                        .cornerRadius(30)
                    Image("iPhoneBezel")
                        .resizable()
                        .frame(width: 270, height: 540)
                }
            }
            .offset(y:30)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    AppStoreScreenShotsView()
}
