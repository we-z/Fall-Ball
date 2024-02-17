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
            RandomGradientView()
            ShockedBall()
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
