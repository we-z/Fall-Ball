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
    @State private var rotationAngle: Double = 0

        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 600, height: 600)
                    
                    
                    ForEach(0..<12) { index in
                        ForEach(0..<15) { index2 in
                            SunRayView(index: index)
                                .rotationEffect(.degrees(Double(index2)))
                        }
                    }
                }
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(Animation.linear(duration: 30).repeatForever(autoreverses: false)) {
                        self.rotationAngle = 360
                    }
                }
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
