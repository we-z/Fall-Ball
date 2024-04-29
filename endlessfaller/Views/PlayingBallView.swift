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
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag})
        let currentCharacter = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) ?? appModel.characters.first(where: { $0.characterID == "io.endlessfall.shocked"})

        if appModel.score >= 0 && appModel.currentIndex >= 0 {
            ZStack{
                if !appModel.isWasted || !appModel.ballIsStrobing {
                    
                    if !appModel.paused && userPersistedData.selectedBag != "jetpack" {
                        VortexView(colourTrail()) {
                            Circle()
                                .fill(.white)
                                .frame(width: 32)
                                .tag("circle")
                        }
                        .offset(y:-30)
                    }
                    
                } else {
                    VortexView(.fire) {
                        Circle()
                            .fill(.white)
                            .blendMode(.plusLighter)
                            .blur(radius: 3)
                            .frame(width: 60)
                            .tag("circle")
                    }
                }
                if userPersistedData.selectedBag == "jetpack" {
                    HStack{
                        VortexView(.fire) {
                            Circle()
                                .fill(.white)
                                .blendMode(.plusLighter)
                                .blur(radius: 3)
                                .frame(width: 30)
                                .tag("circle")
                        }
                        .scaleEffect(0.6)
                        .offset(x: 60)
                        VortexView(.fire) {
                            Circle()
                                .fill(.white)
                                .blendMode(.plusLighter)
                                .blur(radius: 3)
                                .frame(width: 30)
                                .tag("circle")
                        }
                        .scaleEffect(0.6)
                        .offset(x: -60)
                    }
                    .rotationEffect(.degrees(180))
                    .offset(y:18)
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
                .scaleEffect(appModel.ballIsStrobing ? 2.1 : 1.5)
                .animation(.linear(duration: 0.1).repeatForever(autoreverses: true), value: appModel.ballIsStrobing)
            }
            .position(x: deviceWidth / 2, y: self.BallAnimator.ballYPosition)
            .allowsHitTesting(false)
        }
    }
    
    func randomTrail() -> VortexSystem {
        return Bool.random() ? colourTrail() : linesTrail()
    }
    
    func colourTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 0.9
        system.birthRate = 300
        system.shape = .box(width: idiom == .pad ? 0.075 : 0.21, height: 0.1)
        system.angleRange = .degrees(3)
        system.size = 0.3
        system.colors = .random(.blue, .red, .yellow, .green)
        system.sizeVariation = 0.6
        system.lifespan = 0.3
        system.sizeMultiplierAtDeath = 0.1
        return system
    }
    
    func linesTrail() -> VortexSystem {
        let system = VortexSystem(tags: ["circle"])
        system.speed = 2
        system.stretchFactor = 18
        system.birthRate = 60
        system.lifespan = 0.06
        system.shape = .box(width: 0.21, height: 0)
        system.size = 0.1
        system.colors = .random(.black)
        return system
    }
    
}

#Preview {
    PlayingBallView()
}
