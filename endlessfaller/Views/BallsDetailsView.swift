//
//  BallsDetailsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/14/23.
//

import SwiftUI

struct BallsDetailsView: View {
    @StateObject var storeKit = StoreKitManager()
    @StateObject var model = AppModel()
    @State private var isMovingUp = false
    @Binding var ball: Character
    @Binding var ballIndex: Int
    @State var isProcessingPurchase = false
    @Environment(\.dismiss) private var dismiss
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        ZStack{
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
                Button {
                    if ball.isPurchased || ballIndex < 9 {
                        model.selectedCharacter = ball.characterID
                        dismiss()
                    } else {
                        isProcessingPurchase = true
                        Task {
                            do {
                                if (try await storeKit.purchase(characterID: ball.characterID)) != nil{
                                    model.selectedCharacter = ball.characterID
                                    dismiss()
                                }
                            } catch {
                                print("Purchase failed: \(error)")
                            }
                            isProcessingPurchase = false
                        }
                    }
                } label: {
                    HStack{
                        Spacer()
                        Text((ball.isPurchased || ballIndex < 9) ? "EQUIP!" : "OBTAIN! \(ball.cost)")
                            .bold()
                            .italic()
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                        Spacer()
                    }
                    .background(.black)
                    .cornerRadius(30)
                    .padding(.horizontal)
                    .padding(.bottom, idiom == .pad ? 30 : 0)
                }
            }
            if isProcessingPurchase {
                Color.gray.opacity(0.3) // Gray out the background
                    .edgesIgnoringSafeArea(.all)
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.black))
            
            }
        }
        .onAppear() {
            withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                isMovingUp.toggle()
            }
        }
    }
}

#Preview {
    BallsDetailsView( ball: .constant(Character(character: AnyView(WhiteBallView()), cost: "String", characterID: "String", isPurchased: false)), ballIndex: .constant(0))
}
