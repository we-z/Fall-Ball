//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CoreMotion

struct TempView: View {

    @State private var circlePosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: -23)
    @State private var isAnimating: Bool = false

    let timer = Timer.publish(every: 0.005, on: .main, in: .common).autoconnect()
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Circle()
                .frame(height: 50)
                .position(circlePosition)
                .onReceive(timer) { _ in
                    circlePosition.y += 1
                }

            Button("push up") {
                withAnimation {
                    circlePosition.y -= deviceHeight / 3
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
