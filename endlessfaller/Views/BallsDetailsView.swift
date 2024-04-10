//
//  BallsDetailsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/14/23.
//

import SwiftUI

struct BallsDetailsView: View {
    @ObservedObject private var model = AppModel.sharedAppModel
    @State private var isMovingUp = false
    @Binding var ball: Character
    @Binding var ballIndex: Int
    @Environment(\.dismiss) private var dismiss
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @State var showCurrencyPage = false
    @StateObject var userPersistedData = UserPersistedData()
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                Spacer()
                ball.character
                    .scaleEffect(3)
                    .padding(.bottom, 60)
                    .offset(y: isMovingUp ? -30 : 0)
                
                Ellipse()
                    .frame(width: 120, height: 30)
                    .blur(radius: 21)
                    .padding(.bottom, 45)
                if idiom == .pad {
                    Spacer()
                }
                Button{
                    if userPersistedData.boinBalance >= Int(ball.cost)! || userPersistedData.infiniteBoinsUnlocked {
                        userPersistedData.addPurchasedSkin(skinName: ball.characterID)
                        userPersistedData.decrementBalance(amount: Int(ball.cost)!)
                        userPersistedData.selectNewBall(ball: ball.characterID)
                        dismiss()
                    } else {
                        showCurrencyPage = true
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text("OBTAIN:")
                            .bold()
                            .italic()
                            .font(.title)
                            .customTextStroke(width: 1.8)
                            .padding(.vertical)
                        BoinsView()
                        Text("\(ball.cost)")
                            .bold()
                            .italic()
                            .font(.title)
                            .customTextStroke(width: 1.8)
                        Spacer()
                    }
                    .background(.yellow)
                    .cornerRadius(27)
                    .padding(.horizontal, 30)
                    .padding(.bottom, idiom == .pad || UIDevice.isOldDevice ? 30 : 0)
                }
                .buttonStyle(.roundedAndShadow9)
            }
        }
        .onAppear() {
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                isMovingUp.toggle()
            }
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
    }
}

//#Preview {
//    BallsDetailsView( ball: .constant(Character(character: AnyView(WhiteBallView()), cost: "69", characterID: "String")), ballIndex: .constant(0))
//}
