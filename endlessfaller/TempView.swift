//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    @State private var isTouching = false
        
        var body: some View {
            Circle()
                .foregroundColor(isTouching ? .blue : .red)
                .frame(width: 200, height: 200)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            isTouching = true
                        }
                        .onEnded { _ in
                            isTouching = false
                        }
                )
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
