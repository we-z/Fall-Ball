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
            Color(red: 0, green: 0.6, blue: 1)
            Circle()
                .colorInvert()
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
