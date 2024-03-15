//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Vortex

struct InfinityShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let width = rect.width
        let height = rect.height
        
        let start = CGPoint(x: width * 0.5, y: height * 0.25)
        path.move(to: start)

        let control1 = CGPoint(x: width * 0.2, y: height * 0)
        let control2 = CGPoint(x: width * 0.2, y: height * 0.1)
        let end1 = CGPoint(x: width * 0.5, y: height * 0.5)

        path.addCurve(to: end1, control1: control1, control2: control2)

//        let control3 = CGPoint(x: width * 0.95, y: height * 0.75)
//        let control4 = CGPoint(x: width * 0.95, y: height * 0.25)
//        let end2 = CGPoint(x: width * 0.5, y: height * 0.25)
//
//        path.addCurve(to: end2, control1: control3, control2: control4)

        return path
    }
}

struct TempView: View {
    @State private var isAnimating = false

    var body: some View {
        InfinityShape()
            .stroke(lineWidth: 9)
            .frame(width: 200, height: 100)

    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
