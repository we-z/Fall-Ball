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
            GraduationCap()
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
            .frame(width: 150, height: 120)
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
            .frame(width: 120, height: 120)
            .offset(x: 1, y: -39)
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

struct VikingHat: View {
    var body: some View {
        Image("vikinghat")
            .resizable()
            .frame(width: 132, height: 120)
            .offset(y: -36)
    }
}

struct Fedora: View {
    var body: some View {
        Image("fedora")
            .resizable()
            .frame(width: 90, height: 75)
            .offset(x: 1, y: -33)
    }
}

struct Sombrero: View {
    var body: some View {
        Image("sombrero")
            .resizable()
            .frame(width: 90, height: 75)
            .offset( y: -39)
    }
}

struct ClownHat: View {
    var body: some View {
        Image("clownhat")
            .resizable()
            .frame(width: 90, height: 60)
            .offset(y: -47)
    }
}

struct PirateHat: View {
    var body: some View {
        Image("piratehat")
            .resizable()
            .frame(width: 90, height: 90)
            .offset(x: 0.6, y: -45)
    }
}

struct GraduationCap: View {
    var body: some View {
        Image("graduationcap")
            .resizable()
            .frame(width: 120, height: 90)
            .offset(y: -30)
    }
}


#Preview {
    HatDesignsView()
}
