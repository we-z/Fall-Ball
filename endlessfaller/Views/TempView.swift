//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import VTabView
import QuartzCore


struct TempView: View {
    
    @State private var circleProgress: CGFloat = 0.0

        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .trim(from: 0, to: circleProgress)
                        .stroke(Color.blue, lineWidth: 30)
                        .rotationEffect(Angle(degrees: -90)) // Start from top
                }
                .frame(width: 30, height: 30)

            }
            .onAppear{
                withAnimation(.linear(duration: 9)) {
                    circleProgress = 1.0
                }
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
