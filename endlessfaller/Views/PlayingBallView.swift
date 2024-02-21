//
//  PlayingBallView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/17/24.
//

import SwiftUI
import Vortex

struct PlayingBallView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var userPersistedData = UserPersistedData()
    @State var deviceCeiling = 0.0
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag})
        let currentCharacter = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) ?? appModel.characters.first(where: { $0.characterID == "io.endlessfall.shocked"})

        if appModel.score >= 0 && appModel.currentIndex >= 0 {
            ZStack{
                if !appModel.isWasted || !appModel.ballIsStrobing {
                    
//                    HStack{
//                        Divider()
//                            .frame(width: 3)
//                            .overlay(.black)
//                            .offset(x: -21, y: -21)
//                        Divider()
//                            .frame(width: 3)
//                            .overlay(.black)
//                            .offset(y: -39)
//                        Divider()
//                            .frame(width: 3)
//                            .overlay(.black)
//                            .offset(x: 21, y: -21)
//                        
//                    }
//                    .frame(width: 66, height: abs(60 / appModel.ballSpeed))
//                    .offset(x: 0, y:-(60 / appModel.ballSpeed))
                    
                    VortexView(customTrail()) {
                        Circle()
                            .fill(.white)
                            .blur(radius: 1)
                            .frame(width: 32)
                            .tag("circle")
                    }
                    .offset(y:-39)
                } else {
                    VortexView(.fire) {
                        Circle()
                            .fill(.white)
                            .blendMode(.plusLighter)
                            .blur(radius: 3)
                            .frame(width: 45)
                            .tag("circle")
                    }
                }

                ZStack{
                    if userPersistedData.selectedBag != "nobag" {
                        AnyView(bag!.bag)
                    }
                    AnyView(currentCharacter!.character)
                        .scaleEffect(1.5)
                        
                    if userPersistedData.selectedHat != "nohat" {
                        AnyView(hat!.hat)
                    }
                }
                .frame(width: 180, height: 120)
                .opacity(appModel.ballIsStrobing ? 0 : 1)
                .scaleEffect(appModel.ballIsStrobing ? 1.1 : 1)
                .animation(.linear(duration: 0.1).repeatForever(autoreverses: true), value: appModel.ballIsStrobing)
            }
            .position(x: deviceWidth / 2, y: self.BallAnimator.ballYPosition)
            .allowsHitTesting(false)
        }
    }
    
    func customTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 0.2
        system.attractionStrength = 2
        system.speedVariation = 0.2
        system.shape = .box(width: 0.15, height: 0.15)
        system.angleRange = .degrees(10)
        system.size = 0.25
        system.sizeVariation = 0.5
        system.colors = .ramp(.blue, .red, .yellow)
        system.sizeVariation = 0.5
        system.sizeMultiplierAtDeath = 0.1
        return system
    }
    
}

#Preview {
    PlayingBallView()
}
