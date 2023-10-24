//
//  ContinuePlayingView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/22/23.
//

import SwiftUI
import VTabView

struct ContinuePlayingView: View {
    @StateObject var appModel = AppModel()
    @State var showCurrencyPage = false
    @State private var circleProgress: CGFloat = 0.0
    @Binding var cost: Int
    @State var buttonIsPressed = false
    @State var currentIndex: Int = 0
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack{
//            Color.black
//                .opacity(0.2)
//                .ignoresSafeArea()
            //VTabView(selection: $currentIndex){
                VStack{
                    VStack{
                        HStack{
                            Spacer()
                            HStack(spacing: 0){
                                BoinsView()
                                    .scaleEffect(0.6)
                                Text(String(appModel.balance))
                                    .bold()
                                    .italic()
                                    .font(.title3)
                            }
                            .padding(.horizontal, 9)
                            .padding(.top, 12)
                            .padding(.trailing, 21)
                            .background(.yellow)
                            .cornerRadius(15)
                            .overlay{
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.primary, lineWidth: 3)
                            }
                            .offset(x: 9, y: -9)
                        }
                        Text("Continue?")
                            .bold()
                            .italic()
                            .font(.largeTitle)
                            .padding(.bottom, 27)
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
                            if appModel.balance >= cost{
                                appModel.shouldContinue = true
                            } else {
                                showCurrencyPage = true
                            }
                        }
                    }
                    .background(.green)
                    .cornerRadius(21)
                    .overlay{
                        RoundedRectangle(cornerRadius: 21)
                            .stroke(Color.primary, lineWidth: 6)
                            .padding(1)
                        ZStack{
                            Image(systemName: "stopwatch")
                                .bold()
                                .font(.largeTitle)
                                .scaleEffect(2.1)
                            Circle()
                                .frame(width: 59)
                                .foregroundColor(.red)
                                .offset(y:3.6)
                            Circle()
                                .trim(from: 0, to: circleProgress)
                                .stroke(Color.blue, lineWidth: 30)
                                .rotationEffect(Angle(degrees: -90))
                                .frame(width: 29, height: 29)
                                .offset(y:3.6)
                            
                            
                        }
                        .offset(x:-136, y: -99)
                    }
                    .frame(width: 300)
                    .padding(30)
                    
                    VStack{
                        Text("Swipe up\nto cancel")
                            .italic()
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .padding()
                        Image(systemName: "arrow.up")
                            .foregroundColor(.black)
                    }
                    .bold()
                    .font(.largeTitle)                }
                .offset(y: 30)
                .onAppear{
                    withAnimation(.linear(duration: 6).repeatForever(autoreverses: false)) {
                        circleProgress = 1.0
                    }
                }
                
//                Circle()
//                    .foregroundColor(.clear)
//            }
//            .frame(
//                width: deviceWidth,
//                height: deviceHeight
//            )
//            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
//            .edgesIgnoringSafeArea(.all)
//            .onChange(of: currentIndex) { index in
//                appModel.cancelContinuation = true
//            }
            
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
    }
}

#Preview {
    ContinuePlayingView(cost: .constant(1))
}
