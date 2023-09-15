//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CloudKit
import Combine

struct FrameAdjustingContainer<Content: View>: View {
    @Binding var frameWidth: CGFloat
    @Binding var frameHeight: CGFloat
    let content: () -> Content
    
    var body: some View  {
        ZStack {
            content()
                .frame(width: frameWidth, height: frameHeight)
                .border(Color.red, width: 1)
            
            VStack {
                Spacer()
                Slider(value: $frameWidth, in: 50...300)
                Slider(value: $frameHeight, in: 50...600)
            }
            .padding()
        }
    }
}

struct Example3: View {
    @State private var frameWidth: CGFloat = 175
    @State private var frameHeight: CGFloat = 175
    @State private var textSize = CGSize(width: 200, height: 100)
    
    var body: some View {
        FrameAdjustingContainer(frameWidth: $frameWidth, frameHeight: $frameHeight) {
            Text("text")
                .font(.system(size: 300))  // Bigger font size then final rendering
                .fixedSize() // Prevents text truncating
                .background(
                    GeometryReader { (geo) -> Color in
                        DispatchQueue.main.async {  // hack for modifying state during view rendering.
                            textSize = geo.size
                        }
                        return Color.clear
                    }
                )
                .border(Color.blue, width: 1)
                .scaleEffect(min(frameWidth / textSize.width, frameHeight / textSize.height))  // making view smaller to fit the frame.
        }
    }
}

struct TempView: View {
    var body: some View {
        Example3()
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
