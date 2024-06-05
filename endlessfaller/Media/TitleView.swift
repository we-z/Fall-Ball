//
//  TitleView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 9/3/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        ZStack{
            RandomGradientView()
            VStack(spacing: 6){
                Text("FALL")
                    .bold()
                    .font(.largeTitle)
                    .italic()
                    .customTextStroke()
                    
                Text("BALL")
                    .bold()
                    .font(.largeTitle)
                    .italic()
                    .customTextStroke()
                    
            }
            .scaleEffect(3)
            .offset(x:9)
        }
        .ignoresSafeArea()
        
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
