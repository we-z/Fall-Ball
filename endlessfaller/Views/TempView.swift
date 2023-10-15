//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import VTabView
import QuartzCore


struct TempView: View {
//    @State private var showingAlert = false
//    var body: some View {
//        Button("Show Alert") {
//            showingAlert = true
//        }
//        .alert("Fall Ball uploads your scores to Game Center Leaderboards", isPresented: $showingAlert) {
//            Button("OK", role: .cancel) { }
//        }
//    }
    
    @State private var isMovingUp = false
        
        var body: some View {
            VStack {
                Spacer()
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.blue)
                    .offset(y: isMovingUp ? -100 : 100)
                    .animation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true))
                    .onAppear() {
                        isMovingUp.toggle()
                    }
                Spacer()
            }
        }
}

//let gameCenterConsentKey = "gameCenterConsentKey"
//struct TempView: View {
//    @State private var offset = CGFloat.zero
//    @State private var showingAlert = false
//    @AppStorage(gameCenterConsentKey) var gameCenterConsent: Bool = UserDefaults.standard.bool(forKey: gameCenterConsentKey)
//        var body: some View {
//            Button("Show Alert") {
//                        showingAlert = true
//                    }
//                    .alert("Can Fall Ball upload your scores to Game Center Leaderboards?", isPresented: $showingAlert) {
//                        Button("Yes", role: .cancel) {
//                            gameCenterConsent = true
//                        }
//                        Button("No", role: .destructive) {
//                            gameCenterConsent = false
//                        }
//                        
//                    }
//        }
//}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
