//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CoreMotion


struct TempView: View {
//    var body: some View {
//
        
//        
//
//    }
    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @State var currentIndex: Int = 0
    @State var showContinueToPlayScreen = false

    var body: some View {
        ScrollView {
            TabView(selection: $currentIndex) {
                if showContinueToPlayScreen {
                    Text("Dissapeear")
                        .tag(-1)
                }
                ForEach(backgroundColors.indices, id: \.self) { index in
                    ZStack{
                        Color(hex: backgroundColors[index])
                        VStack{
                            Spacer()
                            HStack{
                                Spacer()
                                Text("\(index)")
                                    .font(.largeTitle)
                                    .bold()
                                    .italic()
                                    .scaleEffect(3)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    
                }
            }
            .frame(
                width: deviceWidth,
                height: deviceHeight
            )
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .onChange(of: currentIndex) { newValue in
                if newValue < 6 {
                    showContinueToPlayScreen = true
                }
                if newValue == 6 {
                    showContinueToPlayScreen = false
                    currentIndex = 0
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
    }//view
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
