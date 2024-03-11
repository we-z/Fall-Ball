//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Vortex

struct TempView: View {

        @State private var isAnimating = false

        var body: some View {
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    BoinsView()
                        .offset(y: -50)
                        .rotationEffect(.degrees(Double(index) / Double(5) * 360))
                }
            }
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 3).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                self.isAnimating = true
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
