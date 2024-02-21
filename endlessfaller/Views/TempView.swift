//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Vortex

struct TempView: View {
    var body: some View {
//        VStack{
//            VortexViewReader { proxy in
//                VortexView(.confetti) {
//                    Rectangle()
//                        .fill(.white)
//                        .frame(width: 16, height: 16)
//                        .tag("square")
//                    
//                    Circle()
//                        .fill(.white)
//                        .frame(width: 16)
//                        .tag("circle")
//                }
//                
//                Button("Burst", action: proxy.burst)
//            }
//        }
        
//        VortexView(.fire) {
//            Circle()
//                .fill(.white)
//                .blendMode(.plusLighter)
//                .blur(radius: 3)
//                .frame(width: 45)
//                .tag("circle")
//        }
//        .offset(y:-360)
        ZStack{
            VortexView(customTrail()) {
                Circle()
                    .fill(.white)
                    .blur(radius: 1)
                    .frame(width: 32)
                    .tag("circle")
            }
            .offset(y:-39)
            Circle()
                .frame(width: 75)
        }
    }
    
    func customTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 0.2
        system.attractionStrength = 2
        system.speedVariation = 0.2
        system.shape = .box(width: 0.15, height: 0.15)
        system.angleRange = .degrees(10)
        system.size = 0.25
        system.sizeVariation = 0.5
        system.colors = .ramp(.blue, .red, .yellow)
        system.sizeVariation = 0.5
        system.sizeMultiplierAtDeath = 0.1
        return system
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
