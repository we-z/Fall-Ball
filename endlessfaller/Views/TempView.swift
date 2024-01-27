//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine

struct RandomGradientView: View {
    private var gradient: LinearGradient {
        let colors = backgroundColors.randomElement(randomCount: Int.random(in: 2...5)).map { Color(hex: $0)! }
        let startPoint = UnitPoint.random
        let endPoint = UnitPoint.random
        return LinearGradient(gradient: Gradient(colors: colors), startPoint: startPoint, endPoint: endPoint)
    }

    var body: some View {
        Rectangle()
            .fill(gradient)
            .edgesIgnoringSafeArea(.all)
    }
}

extension Array {
    func randomElement(randomCount: Int) -> [Element] {
        return (0..<randomCount).compactMap { _ in self.randomElement() }
    }
}

extension UnitPoint {
    static var random: UnitPoint {
        return UnitPoint(x: CGFloat.random(in: 0...1), y: CGFloat.random(in: 0...1))
    }
}

struct TempView: View {
        var body: some View {
            RandomGradientView()
        }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
