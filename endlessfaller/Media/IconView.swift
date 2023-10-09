//
//  IconView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/13/23.
//

import SwiftUI

struct IconView: View {
    var body: some View {
        ZStack{
            VStack(spacing: 0){
                Rectangle()
                    .foregroundColor(.blue)
                Rectangle()
                    .foregroundColor(.red)
            }
            
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 230, height: 240)
            .offset(x:0, y:-120)
            
            FallBallShockedBall()
                .scaleEffect(5)
        }
        .ignoresSafeArea()
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
