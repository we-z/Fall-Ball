//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine

struct TempView: View {
    @State private var isGearExpanded = false
    @State private var gearRotationDegrees = 0.0

        var body: some View {
            ZStack {
                ZStack {
                    // Button 1
                    Button(action: {}) {
                        Image(systemName: "shareplay") // Replace with your image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.green)
                    }
                    .offset(y: isGearExpanded ? -180 : 0)

                    // Button 2
                    Button(action: {}) {
                        Image(systemName: "gamecontroller.fill") // Replace with your image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.purple)
                    }
                    .offset(y: isGearExpanded ? -120 : 0)

                    // Button 3
                    Button(action: {}) {
                        Image(systemName: "speaker.wave.2.fill") // Replace with your image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 45, height: 45)
                            .foregroundColor(.teal)
                    }
                    .offset(y: isGearExpanded ? -60 : 0)
                }
                .offset(y: -15)
                .opacity(isGearExpanded ? 1 : 0)

                // Gear Button
                Button(action: {
                    withAnimation {
                        self.gearRotationDegrees += 45
                        self.isGearExpanded.toggle()
                    }
                }) {
                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .rotationEffect(.degrees(gearRotationDegrees))
                }
            }
        }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
