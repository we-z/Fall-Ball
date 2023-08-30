//
//  CharactersDesignsView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import SwiftUI

struct CharactersDesignsView: View {
    var body: some View {
        WastedView()
    }
}


struct IceSpiceView: View {
    var body: some View {
        ZStack {
            Image("afro")
                .resizable()
                .frame(width: 70, height: 60)
                .offset(y: -12)
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .frame(width: 39)
                Circle()
                    .foregroundColor(.orange.opacity(0.3))
                    .frame(width: 39)
                Image("winklash")
                    .resizable()
                    .frame(width: 36, height: 18)
                    .offset(y: -5)
                Text("🫦")
                    .font(.system(size: 12))
                    .offset(y: 10)
            }
            .offset(x: 1)
            Image("afro2")
                .resizable()
                .frame(width: 60, height: 60)
                .offset(y: -12)
            
        }
        .offset(y: 6)
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
            .frame(width: 65, height: 75)
            .mask(
                Rectangle()
                    .frame(width: 61, height: 56)
            )
            .allowsHitTesting(false)
    }
}


struct KaiView: View {
    var body: some View {
        ZStack {
            ZStack{
                Circle()
                    .foregroundColor(Color(hex: "#B06C49"))
                    .frame(width: 46)
                Text("👀")
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 0, z: 1))
                    .offset(x: 6.5, y: -3)
                Image("kaigoatee")
                    .resizable()
                    .frame(width: 12, height: 7)
                    .offset(x: 7, y: 22)
                Image("kaimouth")
                    .resizable()
                    .frame(width: 10, height: 15)
                    .offset(x: 7, y: 12)
            }
            Image("kaihat")
                .resizable()
                .frame(width: 70, height: 56)
                .offset(x: -2, y: -2)
            
        }
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

struct BrazilView: View {
    var body: some View {
        BallView()
            .background(
                Image("Brazil")
                    .resizable()
                    .frame(width: 62, height: 44)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct CanadaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Canada")
                        .resizable()
                        .frame(width: 60, height: 30)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct ColombiaView: View {
    var body: some View {
        BallView()
            .background(
                Image("Colombia")
                    .resizable()
                    .frame(width: 60, height: 45)
                    .mask(
                        Circle()
                            .frame(width: 46, height: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct FranceView: View {
    var body: some View {
        BallView()
            .background(
                Image("France")
                    .resizable()
                    .frame(width: 50, height: 45)
                    .mask(
                        Circle()
                            .frame(width: 46, height: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct GermanyView: View {
    var body: some View {
        BallView()
            .background(
                Image("Germany")
                    .resizable()
                    .frame(width: 50, height: 45)
                    .mask(
                        Circle()
                            .frame(width: 46, height: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct JapanView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("japan")
                        .resizable()
                        .frame(width: 50, height: 33)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct ParaguayView: View {
    var body: some View {
        BallView()
            .background(
                Image("Paraguay")
                    .resizable()
                    .frame(width: 90, height: 50)
                    .mask(
                        Circle()
                            .frame(width: 46, height: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct SouthKoreaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("SouthKorea")
                        .resizable()
                        .frame(width: 43, height: 30)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct UkView: View {
    var body: some View {
        BallView()
            .background(
                Image("Uk")
                    .resizable()
                    .frame(width: 44, height: 44)
                    .mask(
                        Circle()
                            .frame(width: 46, height: 46)
                    )
            )
            .allowsHitTesting(false)
    }
}

struct BallView: View {
    var body: some View {
        Circle()
            .strokeBorder(Color.black,lineWidth: 1.5)
            .allowsHitTesting(false)
            .frame(width: 46, height: 46)
    }
}

struct WhiteBallView: View {
    var body: some View {
        ZStack{
//            Circle()
//                .frame(width: 48)
//                .foregroundColor(.white)
            BallView()
                .background(Circle().foregroundColor(Color.white))
        }
    }
}

struct YinYangBallView: View {
    var body: some View {
        BallView()
            .background(
                Image("yinyang")
                    .resizable()
                    .frame(width: 48, height: 48)
            )
            .allowsHitTesting(false)
    }
}

struct BlackBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 48)
                .foregroundColor(.white)
            BallView()
                .background(Circle().foregroundColor(Color.black))
        }
    }
}

struct ShockedBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 48)
                .foregroundColor(.black)
            Text("😮")
                .font(.system(size: 54))
                .mask(
                    Circle()
                        .frame(width: 46, height: 46)
                )
        }
    }
}

struct BombBallView: View {
    var body: some View {
        ZStack{
            Text("💣")
                .font(.system(size: 51))
        }
    }
}

struct LaughBallView: View {
    var body: some View {
        ZStack{
            Text("🤣")
                .font(.system(size: 49))
        }
    }
}

struct MexicoView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Mexico")
                        .resizable()
                        .frame(width: 69, height: 36)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct PortugalView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Portugal")
                        .resizable()
                        .frame(width: 66, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct SpainView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Spain")
                        .resizable()
                        .frame(width: 66, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct SaudiArabiaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("SaudiArabia")
                        .resizable()
                        .frame(width: 66, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct UaeView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Uae")
                        .resizable()
                        .frame(width: 45, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct QatarView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Qatar")
                        .resizable()
                        .frame(width: 43, height: 44)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct EthiopiaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Ethiopia")
                        .resizable()
                        .frame(width: 90, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct NigeriaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Nigeria")
                        .resizable()
                        .frame(width: 56, height: 39)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct SouthAfricaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("SouthAfrica")
                        .resizable()
                        .frame(width: 44, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct PakistanView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(Color(hex: "#01411c"))
                        .frame(width: 46, height: 46)
                    Image("Pakistan")
                        .resizable()
                        .frame(width: 50, height: 33)
                        .offset(x: -1)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct BangladeshView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(Color(hex: "#006a4e"))
                        .frame(width: 46, height: 46)
                    Image("Bangladesh")
                        .resizable()
                        .frame(width: 50, height: 30)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct IndonesiaView: View {
    var body: some View {
        BallView()
            .background(
                ZStack{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 46, height: 46)
                    Image("Indonesia")
                        .resizable()
                        .frame(width: 43, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            .allowsHitTesting(false)
    }
}

struct WastedView: View {
    var body: some View {
        VStack{
            Text("💀")
                .foregroundColor(.black)
                .bold()
                .font(.largeTitle)
                .scaleEffect(4)
                .padding(.bottom, 90)
                .strobing()
            Text("WASTED")
                .italic()
                .foregroundColor(.red)
                .bold()
                .font(.largeTitle)
                .padding(9)
                .background(.black)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.red, lineWidth: 3)
                )
                .scaleEffect(1.8)
                .strobing()
        }
    }
}

struct CharactersDesignsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDesignsView()
    }
}
