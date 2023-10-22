//
//  ContinuePlayingView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/22/23.
//

import SwiftUI

struct ContinuePlayingView: View {
    @State private var circleProgress: CGFloat = 0.0
    @Binding var cost: Int
    @State var buttonIsPressed = false
    var body: some View {
        ZStack{
            Color.black
                .opacity(0.2)
                .ignoresSafeArea()
            VStack{
                Text("Continue?")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .padding()
                    .padding(.top, 18)
                    .padding(.bottom, 9)
                HStack{
                    Spacer()
                    Text("\(cost)")
                        .bold()
                        .italic()
                        .font(.largeTitle)
                    BoinsView()
                    Spacer()
                }
                .padding(9)
                .background(.yellow)
                .cornerRadius(15)
                .shadow(color: .black, radius: 0.1, x: buttonIsPressed ? 0 : -6, y: buttonIsPressed ? 0 : 6)
                .offset(x: buttonIsPressed ? -6 : -0, y: buttonIsPressed ? 6 : 0)
                .padding(.horizontal, 30)
                .padding(.bottom, 30)
                .pressEvents {
                    // On press
                    withAnimation(.easeInOut(duration: 0.1)) {
                        buttonIsPressed = true
                    }
                } onRelease: {
                    withAnimation {
                        buttonIsPressed = false
                    }
                }
            }
            .background(.white)
            .cornerRadius(21)
            .overlay{
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.primary, lineWidth: 6)
                    .padding(1)
                ZStack{
                    Image(systemName: "stopwatch")
                        .font(.largeTitle)
                        .scaleEffect(2.1)
                    Circle()
                        .frame(width: 59)
                        .foregroundColor(.red)
                        .offset(y:3.9)
                    Circle()
                        .trim(from: 0, to: circleProgress)
                        .stroke(Color.blue, lineWidth: 30)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 29, height: 29)
                        .offset(y:3.9)
                    
                    
                }
                .offset(x:-136, y: -99)
            }

            .frame(width: 300)
            .padding(30)
            
        }
        .onAppear{
            withAnimation(.linear(duration: 9)) {
                circleProgress = 1.0
            }
        }
    }
}

#Preview {
    ContinuePlayingView(cost: .constant(1))
}
