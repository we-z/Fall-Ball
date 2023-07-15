//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    @State private var offset = CGSize.zero

        var body: some View {
            Text("Swipe me!")
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
                .offset(offset)
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            if gesture.translation.height < 0 {
                                offset = gesture.translation
                            }
                        }
                        .onEnded { gesture in
                            offset = CGSize.zero
                        }
                        .simultaneously(with: TapGesture().onEnded { _ in })
                )
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
