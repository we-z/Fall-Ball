//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine

struct TempView: View {

    @State private var circlePosition: CGPoint = CGPoint(x: UIScreen.main.bounds.width / 2, y: -120)
    @State private var timerSubscription: AnyCancellable?
    @State private var speed: Double = 1.0  // Speed factor for the circle's movement
    
    let deviceWidth = UIScreen.main.bounds.width
    let deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack {
            Circle()
                .frame(height: 75)
                .position(circlePosition)
                // The timer now updates the position inside the sink closure
//                .onAppear() {
//                    timerSubscription = Timer.publish(every: 0.003, on: .main, in: .common)
//                        .autoconnect()
//                        .sink { _ in
//                            circlePosition.y += 1
//                        }
//                }
            
            Button("Start Animation") {
                // Start or restart the timer
                circlePosition.y = -120
                timerSubscription?.cancel()
                timerSubscription = Timer.publish(every: 0.003, on: .main, in: .common)
                   .autoconnect()
                   .sink { _ in
                       circlePosition.y += 1
                   }
            }
            


            Button("Push Up") {
                withAnimation {
                    circlePosition.y -= deviceHeight / 2
                }
                // Randomize speed between 0.5 and 2.0, for example
                speed = Double.random(in: 0.001...0.003)
                
                timerSubscription?.cancel()
                
                // Restart timer with new interval
                timerSubscription = Timer.publish(every: speed, on: .main, in: .common)
                     .autoconnect()
                     .sink { _ in
                         circlePosition.y += 1
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
