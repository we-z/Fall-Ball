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
                Divider()
                    .frame(height: 15)
                    .overlay(.black)
                Rectangle()
                    .foregroundColor(.red)
            }
            ZStack{
                ShockedBall()
                    .scaleEffect(5)
                SantaHat()
                    .scaleEffect(3.3)
                    .offset(y: -1)
            }
            .offset(y:30)
        }
        .ignoresSafeArea()
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
