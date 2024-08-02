//
//  AnimationsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/11/23.
//

import SwiftUI
import Vortex

struct AnimationsView: View {
    var body: some View {
        ZStack{
            RandomGradientView()
            BoostAnimation()
        }
    }
}

struct BoostAnimation: View {
    @State var cardYposition = 0.0
    @ObservedObject private var appModel = AppModel.sharedAppModel
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.black)
            VStack{
                Text("Boost!")
                    .bold()
                    .italic()
                    .multilineTextAlignment(.center)
                    .padding()
                    .customShadow(width: 1.2)
                HStack{
                    Image(systemName: "arrow.up")
                    Image(systemName: "arrow.up")
                    Image(systemName: "arrow.up")
                }
                .customShadow(width: 1.2)
                .bold()
            }
            .frame(width: 150, height: 150)
            .background(.blue)
            .cornerRadius(30)
            .font(.system(size: 30))
        }
        .frame(width: 159, height: 159)
        .cornerRadius(33)
        .offset(y: cardYposition)
        .onAppear{
            self.cardYposition = deviceHeight/1.5
            self.appModel.jetPackOn = true
            withAnimation(.linear(duration: 6)) {
                self.cardYposition = -(deviceHeight/1.5)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                self.appModel.jetPackOn = false
                self.appModel.showBoostAnimation = false
                
            }
        }
        .allowsHitTesting(false)
    }
}

struct AnimatedOffsetModifier: ViewModifier {
    let speed: CGFloat
    var distance: CGFloat
    @State private var offsetAmount: CGFloat = 30

    func body(content: Content) -> some View {
        content
            .offset(y: offsetAmount)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: speed).repeatForever(autoreverses: true)) {
                    offsetAmount = distance
                }
            }
    }
}

extension View {
    func animatedOffset(speed amount: CGFloat, distance: CGFloat = -30) -> some View {
        self.modifier(AnimatedOffsetModifier(speed: amount, distance: distance))
    }
}


struct RotatingSunView: View {
    @State private var rotationAngle: Double = 0

        var body: some View {
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 600, height: 600)
                    
                    
                    ForEach(0..<12) { index in
                        ForEach(0..<15) { index2 in
                            SunRayView(index: index)
                                .rotationEffect(.degrees(Double(index2)))
                        }
                    }
                }
                .rotationEffect(.degrees(rotationAngle))
                .onAppear {
                    withAnimation(Animation.linear(duration: 30).repeatForever(autoreverses: false)) {
                        self.rotationAngle = 360
                    }
                }
            }
        }
}

struct SunRayView: View {
    let index: Int

    var body: some View {
        Rectangle()
            .fill(LinearGradient(
                colors: [.clear, .white.opacity(0.1)],
                startPoint: .top,
                endPoint: .bottom
            ))
            .frame(width: 6, height: 300)
            .offset(y: -150)
            .rotationEffect(.degrees(Double(index) * 30))
    }
}

struct SnowView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        
        let screenSize = UIScreen.main.bounds
        let view = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height))
        view.layer.masksToBounds = true
        
        let emitterLayer = CAEmitterLayer()
        emitterLayer.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        emitterLayer.emitterShape = .circle
        emitterLayer.emitterPosition = CGPoint(x: screenSize.width/2, y: -100)
        
        emitterLayer.emitterMode = .surface
        emitterLayer.renderMode = .oldestLast
        
        let cell = CAEmitterCell()
        cell.birthRate = 100
        cell.lifetime = 10
        cell.velocity = 100
        cell.scale = 0.1
        cell.emissionRange = CGFloat.pi
        
        cell.contents = UIImage(named: "snowFlake")?.cgImage
        
        emitterLayer.emitterCells = [cell]
        view.layer.addSublayer(emitterLayer)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
    
}

struct  CelebrationEffect: View {
    @State private var burstCount = 0

    var body: some View {
        VStack{
            VortexViewReader { proxy in
                VortexView(.confetti) {
                    Rectangle()
                        .fill(.white)
                        .frame(width: 16, height: 16)
                        .tag("square")
                    
                    Circle()
                        .fill(.white)
                        .frame(width: 16)
                        .tag("circle")
                }
                .onAppear {
                    // Start a timer when the view appears
                    proxy.burst()
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        if burstCount < 3 {
                            // Call proxy.burst() every second
                            proxy.burst()
                            burstCount += 1
                        } else {
                            // Invalidate the timer after bursting 3 times
                            timer.invalidate()
                        }
                    }
                }
            }
        }
        .allowsHitTesting(false)
        
    }
}

struct KeepSwiping: View {
    var body: some View {
        VStack{
            Text("Keep\nSwiping!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .font(.system(size: 36))
                .scaleEffect(1.5)
                .padding()
            VStack{
                Image(systemName: "arrow.up")
                    .padding(.top, 45)
                    .bold()
                    .font(.system(size: 36))
                    .scaleEffect(1.5)
                SwipeUpHand()
                    .offset(x:60, y:60)
            }
            .animatedOffset(speed: 0.5)
        }
        .frame(width: 300, height: 450)
        
        .customShadow(width: 2)
        .allowsHitTesting(false)
    }
}

struct PodiumButtonView: View {
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
                    .customTextStroke()
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
                    .customTextStroke()
                    
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
                    .customTextStroke()
            }
            .offset(x: 2)
        }
        .font(.largeTitle)
    }
}

struct SwipeUpHand: View {
    var body: some View {
        ZStack{
            Image(systemName: "hand.point.up.left.fill")
                .foregroundColor(.yellow)
                .offset(x:0.3)
        }
        .font(.system(size: 30))
        .scaleEffect(2)
    }
}

struct Instruction2: View {
    var body: some View {
        VStack{
            Text("The ball falls\nat random\nspeeds!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
        }
        .customTextStroke(width: 2)
        .allowsHitTesting(false)
        .font(.system(size: 36))
        .scaleEffect(1.4)
        .flashing()
    }
}

struct Instruction3: View {
    var body: some View {
        VStack{
            Image(systemName: "arrow.up")
                .bold()
                .padding()
            Text("If you hit the top\nor bottom of \nthe screen\nyou lose!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
            Image(systemName: "arrow.down")
                .bold()
                .padding()
        }
        .customTextStroke(width: 2.7)
        .allowsHitTesting(false)
        .font(.system(size: 36))
        .animatedOffset(speed: 1)
    }
}

struct SwipeFaster: View {
    var body: some View {
        VStack{
            Text("Swipe\nFaster!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .font(.system(size: 39))
                .scaleEffect(1.5)
                .padding()
            VStack{
                Image(systemName: "arrow.up")
                    .padding(.top, 60)
                    .bold()
                    .font(.system(size: 39))
                    .scaleEffect(1.5)
                SwipeUpHand()
                    .offset(x:39, y:45)
            }
            .animatedOffset(speed: 0.5)
        }
        .frame(width: 180, height: 450)
        .customTextStroke(width: 3)
        .allowsHitTesting(false)
    }
}

struct JustFaster: View {
    var body: some View {
        VStack{
            Text("Faster!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .font(.system(size: 39))
                .scaleEffect(1.5)
                .padding()
            VStack{
                Image(systemName: "arrow.up")
                    .padding(.top, 45)
                    .bold()
                    .font(.system(size: 39))
                    .scaleEffect(1.5)
                SwipeUpHand()
                    .offset(x:39, y:30)
            }
            .animatedOffset(speed: 0.5)
        }
        .frame(width: 180, height: 360)
        .customTextStroke(width: 3)
        .allowsHitTesting(false)
    }
}

struct SwipeAsFastAsYouCan: View {
    var body: some View {
        VStack{
            Text("Swipe as\nfast as\nyou can!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .font(.system(size: 36))
                .scaleEffect(1.5)
                .padding()
            VStack{
                Image(systemName: "arrow.up")
                    .padding(.top, 60)
                    .bold()
                    .font(.system(size: 36))
                    .scaleEffect(1.5)
                SwipeUpHand()
                    .offset(x:39, y:30)
            }
            .animatedOffset(speed: 0.5)
        }
        .frame(width: 210, height: 410)
        .customTextStroke(width: 3)
        .allowsHitTesting(false)
    }
}

struct SpeedInstruction: View {
    var body: some View {
        VStack{
            Text("The Ball\nWill Fall\nFaster and\nFaster!")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .font(.system(size: 30))
                .scaleEffect(1.5)
                .padding()
            VStack{
                Image(systemName: "arrow.up")
                    .padding(.top, 60)
                    .bold()
                    .font(.system(size: 36))
                    .scaleEffect(1.5)
                SwipeUpHand()
                    .offset(x:39, y:30)
            }
            .animatedOffset(speed: 0.5)
        }
        .frame(width: 240, height: 480)
        .customTextStroke(width: 3)
        .allowsHitTesting(false)
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
            .font(.system(size: 39))
            .customTextStroke()
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
            .font(.system(size: 39))
            .customTextStroke(width: 2.1)
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
            .font(.system(size: 39))
            .customTextStroke(width: 2.1)
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
            .font(.system(size: 39))
            .customTextStroke(width: 2.1)
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
                    .padding(21)
                    .font(.system(size: 33))
                    .customTextStroke(width: 1.8)
                    .allowsHitTesting(false)
            }
        }
        .background(Color.green)
        .cornerRadius(27)
        .flashing()
        .onAppear{
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                dissapear = true
            }
        }
        .allowsHitTesting(false)
    }
}

struct HangTight: View {
    @State var dissapear = false
    var body: some View {
        ZStack{
            RotatingSunView()
                .opacity(0.5)
            Text("Hang tight!\nWe’re grabbing\nyour Boins :)")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: 36))
                .customTextStroke(width:1.8)
        }
        .frame(width: 300, height: 300)
        .background(Color.green)
        .cornerRadius(30)
        .allowsHitTesting(false)
    }
}

struct SomethingWentWrongBoins: View {
    @State var dissapear = false
    var body: some View {
        ZStack{
            Text("Somethng\nwent wrong :(")
                .bold()
                .italic()
                .multilineTextAlignment(.center)
                .padding()
                .font(.system(size: 36))
                .customTextStroke(width: 1.8)
        }
        .frame(width: 300, height: 300)
        .background(Color.red)
        .cornerRadius(30)
        .allowsHitTesting(false)
    }
}


struct WastedView: View {
    // 1. Define a state variable to control the vertical offset
    @State private var shake = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 9){
                Text("💀")
                    .foregroundColor(.black)
                    .bold()
                    .font(.system(size: 120))
                 Text("WASTED!")
                    .foregroundColor(.white)
                    .italic()
                    .bold()
                    .font(.system(size: 54))
            }
            .customShadow(radius: 0.1, width: 2.1)
            .frame(width: 300, height: 300)
//            .background(.red)
            .cornerRadius(60)
            .animatedOffset(speed: 0.1)
            
        }
        .allowsHitTesting(false)
    }
}


struct BoinCollectedView: View {
    // 1. Define a state variable to control the vertical offset
    @State private var scale = false
    @State private var textColor = Color.clear
    @State private var appearFromBottom = false
    @State private var animationEnding = false
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @ObservedObject private var appModel = AppModel.sharedAppModel
    
    var body: some View {
        ZStack {
            CelebrationEffect()
            VStack {
                BoinsView()
                    .scaleEffect(3)
                    .padding(.bottom, 60)
                    .scaleEffect(scale ? 1 : 1.2)
                    .scaleEffect(animationEnding ? 0.2 : 1)
                    .offset(x: animationEnding ? -deviceWidth : 0, y: animationEnding ? -deviceHeight : 0)
                    
                Text("Boin\nFound!")
                    .italic()
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.system(size: 41))
                    .customTextStroke(width: 2.4)
                    .padding(27)
                    .scaleEffect(1.5)
                    .offset(y: animationEnding ? deviceHeight : 0)
            }
            .scaleEffect(appearFromBottom ? 1 : 0)
            .offset(y: appearFromBottom ? 0 : (deviceHeight/2) + 210)
            .onAppear() {
                
                withAnimation(.linear(duration: 1)){
                    self.appearFromBottom = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    self.textColor = Color.black
                    withAnimation(.linear(duration: 0.3).repeatForever(autoreverses: true)){
                        self.scale.toggle()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    
                    withAnimation(.linear(duration: 0.5)){
                        self.animationEnding = true
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    appModel.showBoinFoundAnimation = false
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct DailyBoinCollectedView: View {
    // 1. Define a state variable to control the vertical offset
    @State private var scale = false
    @State private var appearFromTop = false
    @State private var animationEnding = false
    @StateObject var userPersistedData = UserPersistedData()
    
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    
    var body: some View {
        ZStack {
            VStack {
                BoinsView()
                    .scaleEffect(scale ? 1.8 : 2.1)
                Text("Daily Boin\nCollected!")
                    .italic()
                    .bold()
                    .multilineTextAlignment(.center)
                    .font(.system(size: 39))
                    .customTextStroke(width: 2.4)
                    .padding(45)
            }
            .scaleEffect(appearFromTop ? 1 : 0)
            .offset(y: appearFromTop ? -(deviceHeight / 5): -(deviceHeight/2) - 90)
            .offset(y: animationEnding ? -(deviceHeight / 3) : 0)
            .offset(x: animationEnding ? -deviceWidth : 0)
            .onAppear() {
                
                withAnimation(.linear(duration: 1)){
                    self.appearFromTop = true
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    
                    withAnimation(.linear(duration: 0.2).repeatForever(autoreverses: true)){
                        self.scale.toggle()
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    
                    withAnimation(.linear(duration: 0.5)){
                        self.animationEnding = true
                    }
                    userPersistedData.incrementBalance(amount: 1)
                }
            }
        }
        .allowsHitTesting(false)
    }
}

struct LeaderboardRewardView: View {
    @ObservedObject var userPersistedData = UserPersistedData()
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var animationXoffset = 0.0
    @State var animationYoffset = -(deviceHeight / 1.5)
    @State var scaleSize = 1.0
    @State private var rotationAngle: Double = 0
    @State private var isAnimating = false
    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<5, id: \.self) { index in
                    BoinsView()
                        .scaleEffect(1.5)
                        .offset(y: -50)
                        .rotationEffect(.degrees(Double(index) / Double(5) * 360))
                }
            }
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: isAnimating)
            .onAppear {
                self.isAnimating = true
            }
            Text("#1 Place! 🏎️💨")
                .font(.system(size: 39))
                .bold()
                .italic()
                .customTextStroke(width: 2.4)
                .padding(.top, 90)
            
        }
        .scaleEffect(scaleSize)
        .offset(x: animationXoffset, y: animationYoffset)
        .allowsHitTesting(false)
        .onAppear {
            withAnimation(.easeInOut(duration: 2)) {
                animationYoffset = 0
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation(.easeInOut(duration: 2)) {
                    animationYoffset = -(deviceHeight / 1.5)
                    animationXoffset = -deviceWidth / 1.5
                    scaleSize = 0
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                userPersistedData.incrementBalance(amount: 5)
                appModel.show5boinsAnimation = false
            }
        }
    }
}

struct AnimationsView_Previews: PreviewProvider {
    static var previews: some View {
        AnimationsView()
    }
}
