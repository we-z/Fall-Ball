//
//  NewsBannerView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 4/24/24.
//

import SwiftUI

struct NewsBannerView: View {
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            RotatingSunView()
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                HStack{
                    Text("🥳 NEW BALLS! 🥳")
                        .customTextStroke(width: 1.8)
                        .italic()
                        .bold()
                        .font(.largeTitle)
                }
                Spacer()
                HStack(spacing: 15){
                    ElonView()
                        .offset(y: -60)
                        .animatedOffset(speed: 1.2)
                    NinjaBallView()
                        .offset(y: -90)
                        .animatedOffset(speed: 1.8)
                    KanyeView()
                        .offset(y: -60)
                        .animatedOffset(speed: 0.9)
                }
                .offset(y: 90)
                .scaleEffect(2.1)
                .padding(.bottom, 160)
                Text("Get yours in the Ball Shop!")
                    .customTextStroke(width: 1.8)
                    .italic()
                    .bold()
                    .font(.title3)
            }
            .frame(height: 390)
        }
        
    }
}

#Preview {
    NewsBannerView()
}
