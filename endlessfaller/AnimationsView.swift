//
//  AnimationsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/11/23.
//

import SwiftUI

struct AnimationsView: View {
    var body: some View {
        VStack{
            Spacer()
            HStack{
                Spacer()
                SVGCharacterView()
                    .scaleEffect(0.9)
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
