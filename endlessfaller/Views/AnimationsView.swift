//
//  AnimationsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/11/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct AnimationsView: View {
    var body: some View {
        CelebrationEffect()
    }
}

struct BearView: View {
    @State var isVisible: Bool = false
    var body: some View {
        AnimatedImage(name: "bear.gif")
            .frame(width: 200, height: 300)
            .allowsHitTesting(false)
            .scaleEffect(isVisible ? 0.75 : 0)
            .onAppear {
                withAnimation(.easeInOut(duration: 2)) {
                    isVisible = true // Trigger animation when the view appears
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                    withAnimation(.easeInOut(duration: 2)) {
                        isVisible = false // Trigger animation when the view appears
                    }
                }
            }
    }
}

struct SwiftUIXmasTree2: View {
    
    @State private var isSpinning = false
    @State private var isTreeVisible = false
    var body: some View {
        VStack {
            Image(systemName: "wand.and.stars.inverse")
                .font(.system(size: 64))
                .foregroundStyle(EllipticalGradient(
                    colors:[Color.red, Color.green],
                    center: .center,
                    startRadiusFraction: 0.0,
                    endRadiusFraction: 0.5))
                .hueRotation(.degrees(isSpinning ? 0 : 340))
                .animation(.linear(duration: 1).repeatForever(autoreverses: false).delay(0.2), value: isSpinning)
            
            ZStack {
                ZStack {
                    Circle() // MARK: One. No delay
                        .stroke(lineWidth: 2)
                        .frame(width: 20, height: 20)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.4932718873, blue: 0.4739984274, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -10)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 4, height: 4)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: -160)
                
                ZStack {
                    Circle() // MARK: Two. 0.1 delay
                        .stroke(lineWidth: 3)
                        .frame(width: 50, height: 50)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -25)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 6, height: 6)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.1), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: -120)
                
                ZStack {
                    Circle() // Three. 0.2 delay
                        .stroke(lineWidth: 4)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color(#colorLiteral(red: 0.8321695924, green: 0.985483706, blue: 0.4733308554, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -40)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 8, height: 8)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.2), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: -80)
                
                ZStack {
                    Circle() // MARK: Four. 0.3 delay
                        .stroke(lineWidth: 4)
                        .frame(width: 110, height: 110)
                    .foregroundColor(Color(#colorLiteral(red: 0.4500938654, green: 0.9813225865, blue: 0.4743030667, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -55)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 8, height: 8)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.3), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: -40)
                
                ZStack {
                    Circle() // MARK: Five. 0.4 delay
                        .stroke(lineWidth: 4)
                        .frame(width: 140, height: 140)
                        .foregroundColor(Color(#colorLiteral(red: 0.4508578777, green: 0.9882974029, blue: 0.8376303315, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -70)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 10, height: 10)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.4), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 0)
                
                ZStack {
                    Circle() // MARK: Six. 0.5 delay
                        .stroke(lineWidth: 3)
                        .frame(width: 170, height: 170)
                    .foregroundColor(Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -85)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 8, height: 8)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.5), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 40)
                
                ZStack {
                    Circle() // MARK: Seven. 0.6 delay
                        .stroke(lineWidth: 5)
                        .frame(width: 200, height: 200)
                        .foregroundColor(Color(#colorLiteral(red: 0.476841867, green: 0.5048075914, blue: 1, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Image(systemName: "star")
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -100)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.6), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 80)
                
                ZStack {
                    Circle() // MARK: Eight. 0.7 delay
                        .stroke(lineWidth: 4)
                        .frame(width: 230, height: 230)
                        .foregroundColor(Color(#colorLiteral(red: 0.8446564078, green: 0.5145705342, blue: 1, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -115)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 10, height: 10)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.7), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 120)
                
                ZStack {
                    Circle() // MARK: Nine. 0.8 delay
                        .stroke(lineWidth: 5)
                        .frame(width: 260, height: 260)
                        .foregroundColor(Color(#colorLiteral(red: 0.5738074183, green: 0.5655357838, blue: 0, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Circle()
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -130)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .frame(width: 12, height: 12)
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.8), value: isSpinning)
                    }
                }
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 160)
                
                
                ZStack {
                    Circle() // MARK: Ten. 0.9 delay
                        .stroke(lineWidth: 5)
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)))
                    
                    ForEach(0 ..< 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.red)
                            .hueRotation(.degrees(isSpinning ? Double($0) * 310 : Double($0) * 50))
                            .offset(y: -145)
                            .rotationEffect(.degrees(Double($0) * -90))
                            .rotationEffect(.degrees(isSpinning ? 0 : -180))
                            .animation(.linear(duration: 1.5).repeatForever(autoreverses: false).delay(0.9), value: isSpinning)
                    }
                }
                .frame(width: 290, height: 290)
                .rotation3DEffect(.degrees(60), axis: (x: 1, y: 0, z: 0))
                .offset(y: 200)
            }
            .onAppear() {
                isSpinning.toggle()
            }
        }
        .allowsHitTesting(false)
        .scaleEffect(isTreeVisible ? 0.5 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                isTreeVisible = true // Trigger animation when the view appears
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                withAnimation(.easeInOut(duration: 2)) {
                    isTreeVisible = false // Trigger animation when the view appears
                }
            }
        }
    }
}

struct  CelebrationEffect: View {
    @State private var messageEffect = 0

    @State private var acceleration1 = false
    @State private var emitterSize = 0
    @State private var birth = 2

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
                            .animation(Animation.easeInOut(duration: 2).repeatCount(3, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeOut.delay(1.5).repeatCount(3, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.orange)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatCount(3, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.delay(1.5).repeatCount(3, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.cyan)
                            .hueRotation(.degrees(Double(item) *  CGFloat.pi * 2.0))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeIn(duration: 2).repeatCount(3, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeInOut.delay(1.5).repeatCount(3, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.red)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatCount(3, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.repeatCount(3, autoreverses: false), value: acceleration1)
                    }

            }
        }
        .task{
            withAnimation(.linear)
            {
               acceleration1 = true
               emitterSize = 1
               birth = 0
            }
        }
    }
}


struct BubblesView: View {
    @State private var showBubbles = false

    var body: some View {
        ZStack {
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 90))
                .overlay(Text("Nice").font(.title2).bold().foregroundColor(.white).padding(.bottom))
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? -25 : 0))
                .animation(.easeInOut(duration: 2).delay(5).repeatForever(autoreverses: false), value: showBubbles)
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 100))
                .overlay(Text("Flawless").font(.title2).bold().foregroundColor(.white).padding(.bottom))
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .animation(.easeOut(duration: 2).delay(4).repeatForever(autoreverses: false), value: showBubbles)
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 72))
                .overlay(Text("Super").font(.title2).bold().foregroundColor(.white).padding(.bottom))
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .animation(.easeIn(duration: 2).delay(3).repeatForever(autoreverses: false), value: showBubbles)
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 64))
                .overlay(Text("Wow").font(.title2).bold().foregroundColor(.white).padding(.bottom))
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? -25 : 0))
                .animation(.easeInOut(duration: 2).delay(2).repeatForever(autoreverses: false), value: showBubbles)
            Image(systemName: "bubble.right.fill")
                .font(.system(size: 72))
                .overlay(Text("Yepee").font(.title2).bold().foregroundColor(.white).padding(.bottom))
                .scaleEffect(showBubbles ? 1 : 0)
                .offset(y: showBubbles ? -200 : 0)
                .rotationEffect(.degrees(showBubbles ? 25 : 0))
                .animation(.easeOut(duration: 2).delay(1).repeatForever(autoreverses: false), value: showBubbles)
        }
        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
        .onAppear{
            showBubbles.toggle()
        }
    }
}
struct SVGCharacterView: View {
    @State private var isShowing = false
    @State private var isBlinking = false
    @State private var isTalking = false
    @State private var isSVGCharacterVisible = false
    
    var body: some View {
        HStack {
            BubblesView()
            ZStack {
                VStack(alignment: .leading, spacing: -5) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 48))
                        .foregroundStyle(LinearGradient(gradient: Gradient(colors: [Color.red, Color.blue]), startPoint: .leading, endPoint: .trailing))
                        .padding(.horizontal, -50)
                        .hueRotation(.degrees(isShowing ? 0 : 140))
                        .rotationEffect(.degrees(isShowing ? -15 : 50), anchor: .bottomTrailing)
                        .animation(.easeInOut.delay(1).repeatForever(autoreverses: false), value: isShowing)
                    Image("handR")
                }
                .rotationEffect(.degrees(isShowing ? 0 : 25), anchor: .trailing)
                .offset(x: -70)
                .animation(.timingCurve(0.68, -0.9, 0.32, 1.6).delay(1).repeatForever(autoreverses: false), value: isShowing)

                Image("bodyFace")
                VStack(spacing: -10) {
                    HStack {
                        Image("eyeR")
                            .scaleEffect(isBlinking ? 0 : 1)
                            .animation(.timingCurve(0.68, -0.6, 0.32, 1.6).delay(2).repeatForever(autoreverses: false), value: isBlinking)
                        Image("eyeL")
                            .scaleEffect(y: isBlinking ? 0.5 : 1)
                            .animation(.timingCurve(0.68, -0.9, 0.32, 1.6).delay(2).repeatForever(autoreverses: false), value: isBlinking)
                    }
                    Image("mouth2")
                        .padding(.horizontal, -35)
                        .scaleEffect(x: isTalking ? 1 : 0.8, anchor: .top)
                        .animation(.easeIn.delay(0.01).repeatForever(autoreverses: true), value: isTalking)
                        .scaleEffect(y: isTalking ? 0.8 : 1, anchor: .top)
                        .animation(.easeOut.delay(0.01).repeatForever(autoreverses: true), value: isTalking)
                }
                .padding(.horizontal, -45)

                Image("handL")
                    .padding(.top, 120)
                    .offset(x: isShowing ? -2.5 : 2.5)
                    .animation(.timingCurve(0.68, -0.9, 0.32, 1.6).delay(2).repeatForever(autoreverses: true), value: isBlinking)
            }
            .onAppear{
                isShowing.toggle()
                isBlinking.toggle()
                isTalking.toggle()
        }
        }
        .scaleEffect(isSVGCharacterVisible ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                isSVGCharacterVisible = true // Trigger animation when the view appears
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 9) {
                withAnimation(.easeInOut(duration: 2)) {
                    isSVGCharacterVisible = false // Trigger animation when the view appears
                }
            }
        }
    }
}

struct ReactionsView: View {
    @State var showReactions = false
    let deviceHeight = UIScreen.main.bounds.height
    
    var body: some View {
        VStack{
            Spacer()
            HStack {
                ZStack {
                    TearsOfJoyView()
                        .offset(y: showReactions ? -deviceHeight - 100 : -30)
                        .scaleEffect(showReactions ? 3 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .rotationEffect(.degrees(showReactions ? -5 : 5))
                        .animation(Animation.easeInOut(duration: 9).delay(1).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    //Image("handDefault")
                    ClappingHandsEmojiView()
                        .scaleEffect(showReactions ? 5 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .hueRotation(.degrees(showReactions ? -deviceHeight : 0))
                        .offset(x: -20, y: showReactions ? -deviceHeight : -30)
                        .rotationEffect(.degrees(showReactions ? 15 : -30))
                        .animation(Animation.easeOut(duration: 4).delay(1).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    Image("handDefault")
                    //ClappingHandsEmojiView()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                        .scaleEffect(showReactions ? 3 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .hueRotation(.degrees(showReactions ? 0 : 220))
                        .offset(y: showReactions ? -deviceHeight : -30)
                        .rotationEffect(.degrees(showReactions ? -39 : 20))
                        .animation(Animation.easeIn(duration: 4).delay(1).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    //Image("handDefault")
                    ClappingHandsEmojiView()
                }
                .frame(width: 38, height: 38)
                
                ZStack {
                    Image("heart3D")
                    //RevolvingHeartView()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .scaleEffect(showReactions ? 3 : 0, anchor: showReactions ? .bottomLeading: .top)
                        .opacity(showReactions ? 2 : 0)
                        .hueRotation(.degrees(showReactions ? 0 : 220))
                        .offset(y: showReactions ? -deviceHeight - 90: -30)
                        .rotationEffect(.degrees(showReactions ? -7.5 : 15))
                        .animation(Animation.easeOut(duration: 4).delay(1.1).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    RevolvingHeartView()
                        .scaleEffect(showReactions ? 1.2 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .offset(x: -30, y: showReactions ? -deviceHeight - 110 : -30)
                        .rotationEffect(.degrees(showReactions ? -10 : 5))
                        .animation(Animation.easeIn(duration: 4).delay(1).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    HeartExclamationView()
                        .scaleEffect(showReactions ? 5 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .hueRotation(.degrees(showReactions ? 0 : 20))
                        .offset(x: -20, y: showReactions ? -deviceHeight - 90: -35)
                        .rotationEffect(.degrees(showReactions ? -15 : 15))
                        .animation(Animation.easeIn(duration: 4).delay(1.5).repeatCount(2, autoreverses: false), value: showReactions)
                    
                    Image("heart3D")
                        .resizable()
                        .hueRotation(.degrees(330))
                        .scaledToFit()
                        .frame(width: 38, height: 38)
                }
                .frame(width: 38, height: 38)
                
                HandRaisedIn3DY()
                    .scaleEffect(1.4)
            }
            .onAppear {
                showReactions = true
            }
            
        }
        .allowsHitTesting(false)
    }
}

struct HeartExclamationView: View {
    @State private var isYRotating: Double = 0
    
    var body: some View {
        Button {
            // Add tap action
        } label: {
            VStack(spacing: 0) {
                Image("heartExclamation")
                    .rotation3DEffect(.degrees(isYRotating), axis: (x: 0, y: 1, z: 0))
                    .font(.system(size: 128))
                    .animation(.easeOut(duration: 1).repeatForever(autoreverses: false), value: isYRotating)
                    .onAppear {
                        isYRotating = 360
                    }
                Image("circleExclamation")
            }
        }
    }
}

struct HandRaisedIn3DY: View {
    @State private var handIsRaised = false
    
    var body: some View {
        Button {
            // Add tap action
        } label: {
            Image("handRaised")
                .rotation3DEffect(.degrees(handIsRaised ? 0 : -180), axis: (x: 0, y: 1, z: 0))
                .offset(y: handIsRaised ? -150 : 0)
                .onAppear{
                    withAnimation(.easeInOut(duration: 1).delay(0.5).repeatForever(autoreverses: true)){
                        handIsRaised.toggle()
                    }
                }
        }
    }
}

struct ClappingHandsEmojiView: View {
    
    // Initial Animation States
    @State private var blinking = false
    @State private var openingClosing = true
    @State private var clapping = true
    
    var body: some View {
        ZStack {
            Image("head")
            
            VStack {
                ZStack {
                    Image("eyelid")
                    
                    Image("eye_blink")
                    // 1. Eye Blink Animation
                        .scaleEffect(y: blinking ? 0 : 1)
                        .animation(.timingCurve(0.68, -0.6, 0.32, 1.6).delay(1).repeatForever(autoreverses: false), value: blinking)
                }
                
                ZStack {
                    Image("mouth")
                    // 2. Mouth Opening Animation
                        .scaleEffect(x: openingClosing ? 0.7 : 1)
                        .animation(.timingCurve(0.68, -0.6, 0.32, 1.6).delay(1).repeatForever(autoreverses: true), value: openingClosing)
                    
                    
                    HStack {
                        Image("left_hand")
                        // 3. Clapping Animation: Left Hand
                            .rotationEffect(.degrees(clapping ? 15 : -5), anchor: .bottom)
                            .offset(x: clapping ? 20 : -40)
                            .animation(.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: clapping)
                        
                        Image("right_hand")
                        // 4. Clapping Animation: Right Hand
                            .rotationEffect(.degrees(clapping ? -15 : 5), anchor: .bottom)
                            .offset(x: clapping ? -20 : 40)
                            .animation(.easeInOut(duration: 0.2).repeatForever(autoreverses: true), value: clapping)
                    }
                }
                
            }
            .onAppear{
                // Final Animation States
                clapping.toggle()
                blinking.toggle()
                openingClosing.toggle()
            }
            
        }.frame(width: 58, height: 58)
            .scaleEffect(0.13)
        
    }
    
}

struct RevolvingHeartView: View {
    
    @State private var revolving = false
    
    var body: some View {
       
        VStack {
            VStack(spacing: 50) {
                ZStack {
                    ZStack {
                        Image("circular")
                        Image("heart_top")
                        // Do not rotate
                            .rotationEffect(.degrees(revolving ? -360 : 360))
                            .offset(x: 10, y: -20)
                            
                        Image("heart_bottom")
                        // Do not rotate
                            .rotationEffect(.degrees(revolving ? -360 : 360))
                            .offset(x: -25, y: 20)
                                
                    }
                    .rotationEffect(.degrees(revolving ? 360 : -360))
                    .animation(.easeInOut(duration: 5).repeatForever(autoreverses: false), value: revolving)
                    .offset(x: 12.5, y: -20)
                    .onAppear {
                            revolving.toggle()
                    }
                }
            }
        }
            
    }
}


struct TearsOfJoyView: View {
    @State private var isJoyful = false
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 46, height: 46)
                .mask(
                    Circle()
                        .frame(width: 46)
                )
                .overlay{
                    VStack(spacing: -20) {
                        HStack {
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 10)
                                .overlay{
                                    Circle()
                                        .foregroundColor(.yellow)
                                        .frame(width: 15, height: 15)
                                        .offset(y:6.5)
                                }
                            Circle()
                                .foregroundColor(.black)
                                .frame(width: 10)
                                .overlay{
                                    Circle()
                                        .foregroundColor(.yellow)
                                        .frame(width: 15, height: 15)
                                        .offset(y:6.5)
                                }
                        }
                        .rotationEffect(.degrees(isJoyful ? 8 : -8))
                        
                        Image("tearMouth")
                            .resizable()
                            .scaleEffect(isJoyful ? 0.8 : 1)
                            .rotationEffect(.degrees(isJoyful ? 8 : -8))
                            .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isJoyful)
                            .frame(width: 46, height: 46)
                    }
                    .offset(y:9)
                    
                    HStack(spacing: 23){
                        Text("💧")
                            .rotationEffect(.degrees(isJoyful ? 35 : 5), anchor: .topTrailing)
                            .animation(.easeOut(duration: 0.5).repeatForever(autoreverses: true), value: isJoyful)
                            .font(.system(size: 12))
                            .offset( y:6)
                        Text("💧")
                            .rotationEffect(.degrees(isJoyful ? -30 : -15), anchor: .topLeading)
                            .animation(.easeIn(duration: 0.5).repeatForever(autoreverses: true), value: isJoyful)
                            .font(.system(size: 12))
                            .offset(x: -3, y:9)
                    }
                }
        }
        .frame(width: 46, height: 46)
        .onAppear{
            withAnimation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true)) {
                isJoyful.toggle()
            }
        }
    }
}



struct TearsOfJoyBall: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: 46, height: 46)
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 46, height: 46)
                .mask(
                    Circle()
                        .frame(width: 46)
                )
            HStack {
                Circle()
                    .frame(width: 9)
                    .overlay{
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 15, height: 15)
                            .offset(y:6.5)
                    }
                Circle()
                    .frame(width: 9)
                    .overlay{
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 15, height: 15)
                            .offset(y:6.5)
                    }
            }
            .offset(y:-3)
            Circle()
                .foregroundColor(.orange)
                .mask{
                    Rectangle()
                        .frame(height: 14)
                        .offset(y:7)
                }
                .frame(width: 28)
                .offset(y:2)
                .overlay{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 24, height: 2)
                        .offset(y:3.1)
                }
        }
        .frame(width: 46, height: 46)
    }
}

struct KeepSwiping: View {
    var body: some View {
        VStack{
            Text("Keep \nSwiping")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "arrow.up")
        }
        .foregroundColor(.black)
        .allowsHitTesting(false)
        .font(.largeTitle)
        //.flashing()
    }
}

struct PodiumView: View {
    @State var podiumIsPressed = false
    var body: some View {
        HStack(alignment: .bottom, spacing: 0){
            ZStack{
                Rectangle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.purple)
                    .roundedCorner(6, corners: [.topLeft])
                    .background{
                        Rectangle()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.black)
                            .roundedCorner(8, corners: [.topLeft])
                    }
                Text("3")
                    .bold()
                    .font(.system(size: 15))
            }
            ZStack{
                Rectangle()
                    .foregroundColor(.red)
                    .frame(width: 20, height: 40)
                    .roundedCorner(6, corners: [.topLeft, .topRight])
                    .background{
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 24, height: 44)
                            .roundedCorner(7.8, corners: [.topLeft, .topRight])
                    }
                Text("1")
                    .bold()
                    .font(.system(size: 15))
                    .offset(y: -9)
                    
            }
            ZStack{
                Rectangle()
                    .foregroundColor(.blue)
                    .frame(width: 20, height: 30)
                    .roundedCorner(6, corners: [ .topRight])
                    .clipped()
                    .background{
                        Rectangle()
                            .foregroundColor(.black)
                            .frame(width: 24, height: 34)
                            .roundedCorner(8, corners: [ .topRight])
                    }
                Text("2")
                    .bold()
                    .font(.system(size: 15))
                    .offset(y: -3)
            }
            .offset(x: 2)
        }
        .offset(x: podiumIsPressed ? -3 : 0, y: podiumIsPressed ? 3 : 0)
        .font(.largeTitle)
        .pressEvents {
            // On press
            withAnimation(.easeInOut(duration: 0.1)) {
                podiumIsPressed = true
            }
        } onRelease: {
            withAnimation {
                podiumIsPressed = false
            }
        }
    }
}

struct Instruction: View {
    var body: some View {
        VStack{
            Text("Don't let ball\nhit bottom")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "arrow.up")
        }
        .foregroundColor(.black)
        .allowsHitTesting(false)
        .font(.largeTitle)
        //.flashing()
    }
}

struct SwipeFaster: View {
    var body: some View {
        VStack{
            Text("Swipe\nFaster!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "arrow.up")
        }
        .foregroundColor(.black)
        .allowsHitTesting(false)
        .font(.largeTitle)
        //.flashing()
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
            .foregroundColor(.black)
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
            .foregroundColor(.black)
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
            .foregroundColor(.black)
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
            .foregroundColor(.black)
            .flashing()
    }
}

struct NewBestScore: View {
    @State var dissapear = false
    var body: some View {
        VStack{
            if !dissapear{
                Text("New Best Score!")
                    .bold()
                    .italic()
                    
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .flashing()
                    .allowsHitTesting(false)
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                dissapear = true
            }
        }
    }
}

struct WastedView: View {
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
                .strobing()
            VStack{
                Text("💀")
                    .foregroundColor(.black)
                    .bold()
                    .font(.largeTitle)
                    .scaleEffect(3)
                    .padding(.bottom, 40)
                    .strobing()
                Text("WASTED!")
                    .foregroundColor(.black)
                    .italic()
                    .bold()
                    .font(.largeTitle)
                    .padding(9)
                    .scaleEffect(1.5)
                    .strobing()
            }
        }
    }
}

struct AnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationsView()
    }
}
