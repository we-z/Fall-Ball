//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    func decayFunction(x: Double) -> Double {
        return 2 * exp(-0.27 * log(x - 1))
    }
    
    let input = 90
    
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea()
            Text("level \(input): \(decayFunction(x: Double(input))) seconds")
                .foregroundColor(.white)
                .font(.system(size: 30))
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
