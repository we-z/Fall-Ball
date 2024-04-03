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
                    .bold()
                    .italic()
                    .multilineTextAlignment(.center)
            }
            .frame(width: 127)
            .cornerRadius(21)
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
