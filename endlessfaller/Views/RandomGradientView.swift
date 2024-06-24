//
//  RandomGradientView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/15/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins
import RealityKit

struct RandomGradientView: View {
    // Define a state for the gradient to trigger updates
    @State private var gradient: LinearGradient = LinearGradient(gradient: Gradient(colors: backgroundColors.randomElement(randomCount: 3).map { Color(hex: $0)! }), startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: 1, y: 1))
    
    private var texture: TextureResource? {
        let smoothLinearGradient = CIFilter.smoothLinearGradient()
        smoothLinearGradient.point0 = CGPoint(x: 0, y: 0)
        smoothLinearGradient.point1 = CGPoint(x: 1, y: 1)
//        smoothLinearGradient.color0 = gradient.gradient.stops.first?.color.sec
//          smoothLinearGradient.color1 = CIColor(red: 216/255, green: 232/255, blue: 146/255)
        guard let image = smoothLinearGradient.outputImage?.cgImage! else {
            return nil
        }
        if #available(visionOS 2.0, *) {
            return try? TextureResource(image: image, options: .init(semantic: .color))
        } else {
            // Fallback on earlier versions
            return nil
        }
    }
    
    
    
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
