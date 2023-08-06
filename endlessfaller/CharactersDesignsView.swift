//
//  CharactersDesignsView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import SwiftUI

struct CharactersDesignsView: View {
    var body: some View {
        VStack{
            HStack{
                AmericaView()
                RickView()
                KaiView()
                IceSpiceView()
            }
            Spacer()
        }
    }
}


struct IceSpiceView: View {
    var body: some View {
        Image("icespice")
            .resizable()
            .frame(width: 60, height: 60)
            .allowsHitTesting(false)
    }
}

struct RickView: View {
    var body: some View {
        Image("rick")
            .resizable()
            .frame(width: 60, height: 60)
            .allowsHitTesting(false)
    }
}

struct MortyView: View {
    var body: some View {
        Image("morty")
            .resizable()
            .frame(width: 56, height: 56)
            .allowsHitTesting(false)
    }
}

struct AlbertView: View {
    var body: some View {
        Image("albert")
            .resizable()
            .frame(width: 60, height: 60)
            .allowsHitTesting(false)
    }
}

struct MonkeyView: View {
    var body: some View {
        Image("monkey")
            .resizable()
            .frame(width: 45, height: 45)
            .offset(x:1)
            .allowsHitTesting(false)
    }
}

struct KaiView: View {
    var body: some View {
        Image("kai")
            .resizable()
            .frame(width: 57, height: 57)
            .allowsHitTesting(false)
    }
}

struct AmericaView: View {
    var body: some View {
        BallView()
            .background(
                Image("america")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}
struct ChinaView: View {
    var body: some View {
        BallView()
            .background(
                Image("china")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:18, y: 3)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct IndiaView: View {
    var body: some View {
        BallView()
            .background(
                Image("india")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}


struct CharactersDesignsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDesignsView()
    }
}
