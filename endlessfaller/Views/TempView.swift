//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {

    var body: some View {
        ZStack{
            RandomGradientView()
            VStack{
                Text("Free him!")
                    .font(.largeTitle)
                    .multilineTextAlignment(.center)
                    .bold()
                    .italic()
                    .multilineTextAlignment(.center)
                    .customTextStroke()
            }
            .frame(width: 127)
            .background(Color.primary.opacity(0.1))
            .cornerRadius(21)
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
