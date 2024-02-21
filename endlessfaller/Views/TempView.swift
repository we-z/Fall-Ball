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
        VortexView(customTrail()) {
            Circle()
                .fill(.white)
                .frame(width: 32)
                .tag("circle")
        }
        
    }
    
    func customTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 2
        system.stretchFactor = 18
        system.birthRate = 60
        system.lifespan = 0.06
        system.shape = .box(width: 0.15, height: 0)
        system.size = 0.1
        system.colors = .random(.black)
        return system
    }
    
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
