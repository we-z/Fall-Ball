//
//  BoinInfoView.swift
//  Fall Ball
//
//  Created by Wheezy Capowdis on 6/28/24.
//

import SwiftUI

struct BoinInfoView: View {
    var body: some View {
        ZStack{
            RandomGradientView()
            RotatingSunView()
                .frame(height: 300)
                .offset(y:30)
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                Text("🤨 What is a Boin? 🤨")
                    .bold()
                    .italic()
                    .font(.system(size: 30))
                    .customTextStroke(width: 1.8)
                Spacer()
                Text("A Boin is a ball coin!\nUse them to buy cool skins\nand continue playing\nafter getting wasted 💀")
                    .multilineTextAlignment(.center)
                    .bold()
                    .italic()
                    .font(.system(size: 27))
                    .customTextStroke(width: 1.5)
                Spacer()
            }
            .frame(width: deviceWidth)
        }
    }
}

#Preview {
    BoinInfoView()
}
