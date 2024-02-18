//
//  PlayingBallView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/17/24.
//

import SwiftUI

struct PlayingBallView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @ObservedObject var BallAnimator = BallAnimationManager.sharedBallManager
    @StateObject var userPersistedData = UserPersistedData()
    @State var deviceCeiling = 0.0
    
    var body: some View {
        let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat})
        let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag})
        if appModel.score >= 0 && appModel.currentIndex >= 0 {
            ZStack{
                if !appModel.isWasted{
                    HStack{
                        Divider()
                            .frame(width: 3)
                            .overlay(.black)
                            .offset(x: -21, y: -21)
                        Divider()
                            .frame(width: 3)
                            .overlay(.black)
                            .offset(y: -39)
                        Divider()
                            .frame(width: 3)
                            .overlay(.black)
                            .offset(x: 21, y: -21)
                        
                    }
                    .frame(width: 66, height: abs(60 / appModel.ballSpeed))
                    .offset(x: 0, y:-(60 / appModel.ballSpeed))
                }

                if let character = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter}) {
                    ZStack{
                        if userPersistedData.selectedBag != "nobag" {
                            AnyView(bag!.bag)
                        }
                        AnyView(character.character)
                            .scaleEffect(1.5)
                        if userPersistedData.selectedHat != "nohat" {
                            AnyView(hat!.hat)
                        }
                    }
                    .opacity(appModel.ballIsStrobing ? 0.3 : 1)
                    .scaleEffect(appModel.ballIsStrobing ? 1.2 : 1)
                    .animation(.linear(duration: 0.1).repeatForever(autoreverses: true), value: appModel.ballIsStrobing)
                }
            }
            .position(x: deviceWidth / 2, y: self.BallAnimator.ballYPosition)
            .allowsHitTesting(false)
        }
    }
}

#Preview {
    PlayingBallView()
}
