//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CoreMotion

struct TempView: View {

    let deviceHeight = UIScreen.main.bounds.height
    let deviceWidth = UIScreen.main.bounds.width
    @State var currentIndex: Int = 0
    @State var showContinueToPlayScreen = false

    var body: some View {
        ZStack{
            Color.blue
            SnowView()
        }
        .ignoresSafeArea()
    }//view
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
