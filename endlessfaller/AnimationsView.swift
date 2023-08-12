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
                            .animation(Animation.easeInOut(duration: 2).repeatCount(2, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeOut.delay(1.5).repeatCount(2, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 4, height: 8)
                            .foregroundColor(.orange)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatCount(2, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.delay(1.5).repeatCount(2, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 6, height: 12)
                            .foregroundColor(.cyan)
                            .hueRotation(.degrees(Double(item) *  CGFloat.pi * 2.0))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeIn(duration: 2).repeatCount(2, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeInOut.delay(1.5).repeatCount(2, autoreverses: false), value: acceleration1)

                        Capsule()
                            .frame(width: 4, height: 8)
                            .foregroundColor(.red)
                            .hueRotation(.degrees(Double(item) *  30))
                            .blendMode(.exclusion)
                            .scaleEffect(CGFloat(emitterSize))
                            .offset(y: CGFloat(acceleration1 ? 300 : 5))
                            .rotationEffect(.degrees(Double(item) * 30), anchor: .bottom)
                            .animation(Animation.easeOut(duration: 2).repeatCount(2, autoreverses: false), value: acceleration1)
                            .opacity(Double(birth))
                            .animation(Animation.easeIn.repeatCount(2, autoreverses: false), value: acceleration1)
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
                        .scaleEffect(showReactions ? 1 : 0, anchor: showReactions ? .bottomLeading: .bottomTrailing)
                        .rotationEffect(.degrees(showReactions ? -5 : 5))
                        .animation(Animation.easeInOut(duration: 4).delay(1).repeatCount(2, autoreverses: false), value: showReactions)
                    
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
            Image("tearHead")
            
            VStack(spacing: -30) {
                Image("joyEyes")
                    .rotationEffect(.degrees(isJoyful ? -16 : 8))
                
                Image("tearMouth")
                    .resizable()
                    .frame(width: 33, height: isJoyful ? 32 : 28)
                    .scaleEffect(isJoyful ? 0.8 : 1)
                    .rotationEffect(.degrees(isJoyful ? 8 : -8))
                    .animation(.easeInOut(duration: 0.5).repeatForever(autoreverses: true), value: isJoyful)
            }
            
            
            HStack(spacing: 12){
                Image("tearRight")
                    .rotationEffect(.degrees(isJoyful ? 5 : -30), anchor: .topTrailing)
                    .animation(.easeOut(duration: 0.25).repeatForever(autoreverses: true), value: isJoyful)
                
                Image("tearLeft")
                    .rotationEffect(.degrees(isJoyful ? -30 : 5), anchor: .topLeading)
                    .animation(.easeIn(duration: 0.25).repeatForever(autoreverses: true), value: isJoyful)
            }
        }.scaleEffect(3)
            .onAppear{
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    isJoyful.toggle()
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

struct NewBestScore: View {
    @State var dissapear = false
    var body: some View {
        VStack{
            if !dissapear{
                Text("New Best Score!")
                    .bold()
                    .italic()
                    .allowsHitTesting(false)
                    .multilineTextAlignment(.center)
                    .padding()
                    .font(.largeTitle)
                    .flashing()
            }
        }
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                dissapear = true
            }
        }
    }
}


struct AnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationsView()
    }
}
