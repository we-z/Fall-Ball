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
            VStack(spacing: 0){
                Rectangle()
                    .foregroundColor(.blue)
                Rectangle()
                    .foregroundColor(.red)
            }
            VStack{
                Text("FALL")
                    .bold()
                    .font(.largeTitle)
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.5, x: -3, y: 3)
                    .offset(x:3)
                Text("BALL")
                    .bold()
                    .font(.largeTitle)
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 0.5, x: -3, y: 3)
                    
            }
            .scaleEffect(4)
        }
        .ignoresSafeArea()
        
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
