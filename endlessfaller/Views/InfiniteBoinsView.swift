//
//  InfiniteBoinsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/15/24.
//

import SwiftUI

struct InfiniteBoinsView: View {
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
                Spacer()
                ZStack{
                    VStack{
                        Text("∞")
                            .font(.system(size: 180))
                            .bold()
                            .italic()
                            .padding(1)
                            .animatedOffset(speed: 2)
                        Text("Infinite Boins\nUnlocked\n🔓")
                            .font(.largeTitle)
                            .bold()
                            .italic()
                            .multilineTextAlignment(.center)
                            .scaleEffect(1.5)
                    }
                    .customTextStroke()
                    .offset(y:-60)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    InfiniteBoinsView()
}
