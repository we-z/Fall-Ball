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
                Color(red: 0, green: 0.3, blue: 1)
                Color(red: 1, green: 0, blue: 0)
            }
            
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .white.opacity(0.75)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 250, height: 240)
            .offset(x:0, y:-90)
            
            KaiView()
                .offset(x:2)
                .scaleEffect(5)
            
            HStack{
                Spacer()
                Text("l")
            }
        }
    }
}

struct IconView_Previews: PreviewProvider {
    static var previews: some View {
        IconView()
    }
}
