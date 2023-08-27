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
                
                Color(red: 0.6, green: 0, blue: 1)
                Color(red: 0, green: 0.8, blue: 1)
            }
            
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 260, height: 240)
            .offset(x:0, y:-117)
            
            LaughBallView()
                .scaleEffect(6)
                .offset(x:3)
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
