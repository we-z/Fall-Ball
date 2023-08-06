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
                Color(red: 0, green: 0.9, blue: 1)
                Color(red: 1, green: 0.6, blue: 0.9)
            }
            
            VStack{
                LinearGradient(
                    colors: [.gray.opacity(0.01), .gray.opacity(0.6)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .frame(width: 180, height: 210)
            .offset(x: 0, y:-100)
            
            Circle()
                .strokeBorder(Color.primary,lineWidth: 6)
                .background(Circle().foregroundColor(Color.white))
                .frame(width: 180)
            
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
