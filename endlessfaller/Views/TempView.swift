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
    
    @State private var isMovingUp = false
        
        var body: some View {
            Text("Hello, World!")
                .animatedOffset(speed: 2)
                        .padding()
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
