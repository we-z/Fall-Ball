//
//  ContinuePlayingView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/22/23.
//

import SwiftUI

struct ContinuePlayingView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @State var showCurrencyPage = false
    @State private var circleProgress: CGFloat = 0.0
    @State var buttonIsPressed = false
    @StateObject var userPersistedData = UserPersistedData()
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    
    // Timer related states
        @State private var timer: Timer? = nil
        @State private var animationDuration: CGFloat = 6.0 // Total duration of the animation
        @State private var currentTime: CGFloat = 0.0 // Current time elapsed
    
    // Function to start the timer and control the animation
    private func startAnimationTimer() {
        // Reset the progress and current time
        self.circleProgress = 0.0
        self.currentTime = 0.0
        
        // Configure and start the timer
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
            self.currentTime += 0.05 // Increment the current time
            let progress = self.currentTime / self.animationDuration
            
            if progress >= 1.0 {
                self.circleProgress = 1.0
                timer.invalidate() // Stop the timer if the animation is complete
            } else {
                self.circleProgress = progress
            }
        }
        }
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    HStack(spacing: 0){
                        BoinsView()
                            .scaleEffect(0.6)
                        Text(String(userPersistedData.boinBalance))
                            .bold()
                            .italic()
                            .font(.title)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal, 9)
                    .padding(.top, 12)
                    .padding(.trailing, 21)
                    .background(.yellow)
                    .cornerRadius(15)
                    .overlay{
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.black, lineWidth: 3)
                    }
                    .offset(x: 9, y: -9)
                }
                Text("Continue?")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .padding(.bottom, 27)
                    .foregroundColor(.black)
                Button {
                    if userPersistedData.boinBalance >= appModel.costToContinue{
                        userPersistedData.decrementBalance(amount: appModel.costToContinue)
                        appModel.continuePlaying()
                    } else {
                        showCurrencyPage = true
                    }
                } label: {
                    
                    HStack{
                        Spacer()
                        Text("\(appModel.costToContinue)")
                            .bold()
                            .italic()
                            .font(.largeTitle)
                            .scaleEffect(1.2)
                            .padding(.trailing, 3)
                            .foregroundColor(.black)
                        BoinsView()
                        Spacer()
                    }
                    .padding(9)
                    .background(.yellow)
                    .cornerRadius(15)
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)

                }
                .buttonStyle(.roundedAndShadow6)
                
            }
            .background(.orange)
            .cornerRadius(21)
            .overlay{
                RoundedRectangle(cornerRadius: 21)
                    .stroke(Color.black, lineWidth: 6)
                    .padding(1)
                ZStack{
                    Image(systemName: "stopwatch")
                        .bold()
                        .font(.system(size: 33))
                        .scaleEffect(2.1)
                        .foregroundColor(.black)
                    Circle()
                        .frame(width: 59)
                        .foregroundColor(.white)
                        .offset(y:3.6)
                    Circle()
                        .frame(width: 50)
                        .foregroundColor(.blue)
                        .offset(y:3.6)
                    Circle()
                        .trim(from: 0, to: circleProgress)
                        .stroke(Color.white, lineWidth: 29)
                        .rotationEffect(Angle(degrees: -90))
                        .frame(width: 29)
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
            .padding(60)
            .bold()
            .font(.largeTitle)
            .animatedOffset(speed: 1)
            .scaleEffect(1.2)
        }
        .offset(y: UIDevice.isOldDevice ? 60 : 90)
        .scaleEffect(UIDevice.isOldDevice ? 0.7 : 1)
        .onAppear{
            // Initialize the timer and the animation process
            self.startAnimationTimer()
        }
        .onDisappear {
            // Invalidate the timer when the view disappears to stop the animation
            self.timer?.invalidate()
        }
        .sheet(isPresented: self.$showCurrencyPage){
            CurrencyPageView()
        }
    }
}

#Preview {
    ContinuePlayingView()
}
