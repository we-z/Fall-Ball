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
            
//            HStack{
//                Divider()
//                    .frame(width: 3)
//                    .overlay(.black)
//                    .offset(x: -34)
//                Divider()
//                    .frame(width: 3)
//                    .overlay(.black)
//                    .offset(y: -24)
//                Divider()
//                    .frame(width: 3)
//                    .overlay(.black)
//                    .offset(x: 34)
//                
//            }
//            .frame(width: 69, height: 12)
//            .offset(x: 0, y: -32)
//            .scaleEffect(3)
//            
            FallBallShockedBall()
                .scaleEffect(6)
        }
        .ignoresSafeArea()
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
