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
            AlbertView()
            MonkeyView()
            IceSpiceView()
        }
    }
}

struct IceSpiceView: View {
    var body: some View {
        ZStack {
            Image("afro")
                .resizable()
                .frame(width: 90, height: 80)
                .offset(y: -15)
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 46)
                Circle()
                    .foregroundColor(.orange.opacity(0.3))
                    .frame(width: 46)
                Image("winklash")
                    .resizable()
                    .frame(width: 40, height: 20)
                    .offset(y: -7)
                Text("🫦")
                    .font(.system(size: 20))
                    .offset(y: 12)
            }
            .offset(x: 1)
            Image("afro2")
                .resizable()
                .frame(width: 80, height: 80)
                .offset(y: -15)
            
        }
        .offset(y: 15)
        .allowsHitTesting(false)
    }
}

struct AlbertView: View {
    var body: some View {
        ZStack {
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 46)
                Circle()
                    .foregroundColor(.orange.opacity(0.3))
                    .frame(width: 46)
                Text("👀")
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                    .offset(x: -3, y: -3)
                Image("alberttongue")
                    .resizable()
                    .frame(width: 18, height: 15)
                    .offset(x: -2, y: 15)
            }
            Image("alberthair")
                .resizable()
                .frame(width: 70, height: 50)
                .offset(x: 0, y: -5)
            
        }
        .allowsHitTesting(false)
    }
}

struct MonkeyView: View {
    var body: some View {
        Image("monkey")
            .resizable()
            .frame(width: 70, height: 80)
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
