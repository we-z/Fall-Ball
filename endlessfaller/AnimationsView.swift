//
//  AnimationsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/11/23.
//

import SwiftUI

struct AnimationsView: View {
    var body: some View {
        CelebrationEffect()
    }
}

struct  CelebrationEffect: View {
    @State private var messageEffect = 0

    @State private var acceleration1 = false
    @State private var emitterSize = 0
    @State private var birth = 1
    
    var body: some View {
        ZStack {
            ForEach(0 ..< 12) { item in
               
                    VStack(spacing: 100) {
                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.teal)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeInOut(duration: 2).repeatForever(autoreverses: false))
                            .opacity(Double(birth))
                            .animation(Animation.easeOut.delay(1.5).repeatForever(autoreverses: false))
                        
                        Capsule()
                            .frame(width: 4, height: 8)
                            .foregroundColor(.orange)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false))
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.delay(1.5).repeatForever(autoreverses: false))
                        
                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.cyan)
                            .hueRotation(.degrees(Double(item) *  CGFloat.pi * 2.0))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeIn(duration: 2).repeatForever(autoreverses: false))
                            .opacity(Double(birth))
                            .animation(Animation.easeInOut.delay(1.5).repeatForever(autoreverses: false))
                        
                        Capsule()
                            .frame(width: 4, height: 8)
                            .foregroundColor(.red)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatForever(autoreverses: false))
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.repeatForever(autoreverses: false))
                    }
                    
            }
        }
        .task{
            withAnimation
            {
               acceleration1 = true
               emitterSize = 1
               birth = 0
            }
        }
    }
}


struct KeepSwiping: View {
    var body: some View {
        VStack{
            Text("Keep \nswiping")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "arrow.up")
        }
        .allowsHitTesting(false)
        .font(.largeTitle)
        .blinking()
    }
}

struct KeepGoing: View {
    var body: some View {
        Text("Keep Going!")
            .bold()
            .italic()
            .allowsHitTesting(false)
            .multilineTextAlignment(.center)
            .padding()
            .font(.largeTitle)
            .flashing()
    }
}

struct YourGood: View {
    var body: some View {
        Text("You're Good!")
            .bold()
            .italic()
            .allowsHitTesting(false)
            .multilineTextAlignment(.center)
            .padding()
            .font(.largeTitle)
            .flashing()
    }
}

struct YourInsane: View {
    var body: some View {
        Text("You're insane!!")
            .bold()
            .italic()
            .allowsHitTesting(false)
            .multilineTextAlignment(.center)
            .padding()
            .font(.largeTitle)
            .flashing()
    }
}

struct GoBerzerk: View {
    var body: some View {
        Text("GO BERZERK!!!")
            .bold()
            .italic()
            .allowsHitTesting(false)
            .multilineTextAlignment(.center)
            .padding()
            .font(.largeTitle)
            .flashing()
    }
}

struct AnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationsView()
    }
}
