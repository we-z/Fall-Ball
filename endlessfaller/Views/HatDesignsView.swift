//
//  HatDesignsView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/16/23.
//

import SwiftUI

struct HatDesignsView: View {
    var body: some View {
        ZStack{
            ShockedBall()
                .scaleEffect(1.5)
            SantaHat()
        }
    }
}

struct TopHat: View {
    var body: some View {
            Text("🎩")
                .font(.system(size: 60))
                .offset(y: -45)
    }
}

struct Crown: View {
    var body: some View {
            Text("👑")
                .font(.system(size: 60))
                .offset(y: -45)
    }
}

struct WizardHat: View {
    var body: some View {
        Image("wizardhat")
            .resizable()
            .frame(width: 120, height: 90)
            .offset(y: -40)
    }
}

struct ChefsHat: View {
    var body: some View {
        Image("chefshat")
            .resizable()
            .frame(width: 100, height: 60)
            .offset(y: -40)
    }
}

struct PropellerHat: View {
    var body: some View {
        Image("propellerhat")
            .resizable()
            .frame(width: 90, height: 45)
            .offset(x: 1, y: -33)
    }
}

struct CaptainHat: View {
    var body: some View {
        Image("captainhat")
            .resizable()
            .frame(width: 90, height: 45)
            .offset(x: 1, y: -33)
    }
}

struct CowboyHat: View {
    var body: some View {
        Image("cowboyhat")
            .resizable()
            .frame(width: 90, height: 90)
            .offset(x: 1, y: -41)
    }
}

struct SantaHat: View {
    var body: some View {
        Image("santahat")
            .resizable()
            .frame(width: 81, height: 57)
            .offset(x: 8, y: -30)
    }
}

#Preview {
    HatDesignsView()
}
