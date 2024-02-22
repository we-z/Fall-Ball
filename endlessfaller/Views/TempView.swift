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
        VortexView(colourTrail()) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .tag("circle")
        }
        
    }
    
    func colourTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 0.9
        system.birthRate = 300
        system.shape = .box(width: 0.15, height: 0.1)
        system.angleRange = .degrees(3)
        system.size = 0.3
        system.colors = .random(.blue, .red, .yellow, .green)
        system.sizeVariation = 0.6
        system.lifespan = 0.3
        system.sizeMultiplierAtDeath = 0.1
        return system
    }
    
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
