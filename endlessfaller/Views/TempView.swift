//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Vortex

struct TempView: View {
    @State private var burstCount = 0

    var body: some View {
        VStack{
            VortexViewReader { proxy in
                VortexView(.confetti) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 16, height: 16)
                        .tag("square")
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
                .onAppear {
                    // Start a timer when the view appears
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if burstCount < 4 {
                            // Call proxy.burst() every second
                            proxy.burst()
                            burstCount += 1
                        } else {
                            // Invalidate the timer after bursting 3 times
                            timer.invalidate()
                        }
                    }
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
