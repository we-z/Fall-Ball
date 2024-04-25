//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    func decayFunction(x: Double) -> Double {
        return 2 * exp(-0.21 * log(x - 1))
    }

    var body: some View {
        VStack{
            Text("level 2: \(decayFunction(x: Double(155)))")
                .font(.system(size: 30))
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
