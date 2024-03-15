//
//  RandomGradientView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/15/24.
//

import SwiftUI

struct RandomGradientView: View {
    // Define a state for the gradient to trigger updates
    @State private var gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    // Timer to change the gradient periodically
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        Rectangle()
            .fill(gradient)
            .edgesIgnoringSafeArea(.all)
            .onAppear{
                // Animate the change
                if !UIDevice.isOldDevice {
                    withAnimation(.linear(duration: 3)) {
                        self.gradient = self.randomGradient()
                    }
                }
            }
            .onReceive(timer) { _ in
                // Generate a new gradient
                // Animate the change
                if !UIDevice.isOldDevice {
                    withAnimation(.linear(duration: 3)) {
                        self.gradient = self.randomGradient()
                    }
                }
            }
    }
    
    func randomGradient() -> LinearGradient {
        let colors = backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }
        let startPoint = UnitPoint(x: 0, y: 0)
        let endPoint = UnitPoint(x: 1, y: 1)
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }
}

#Preview {
    RandomGradientView()
}
