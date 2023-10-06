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
    @State private var isAssistiveTouchEnabled = false

        var body: some View {
            ScrollView {
                VStack {
                    ForEach(1...20, id: \.self) { index in
                        Text("Item \(index)")
                            .padding()
                    }
                }
            }
            .disabled(isAssistiveTouchEnabled)
            .onAppear {
                // Check the status of AssistiveTouch
                isAssistiveTouchEnabled = UIAccessibility.isAssistiveTouchRunning
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
