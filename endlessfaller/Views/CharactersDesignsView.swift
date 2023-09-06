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
                SouthKoreaView()
                AlbertView()
                //                .shadow(color: .black, radius: 0.1, x: -3, y: 3)
                IceSpiceView()
                KaiView()
                LaughBallView()
            }
            Spacer()
        }
    }
}


struct IceSpiceView: View {
    var body: some View {
        Image("icespiceball")
            .resizable()
            .frame(width: 56, height: 52)
            .allowsHitTesting(false)
    }
}

struct RickView: View {
    var body: some View {
        Image("rick")
            .resizable()
            .frame(width: 60, height: 60)
            //.allowsHitTesting(false)
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
        Image("albertball")
            .resizable()
            .frame(width: 56, height: 48)
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
        Image("kaiball")
            .resizable()
            .frame(width: 56, height: 48)
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
            Circle()
                .frame(width: 48)
                .foregroundColor(.black)
            Circle()
                .frame(width: 46)
                .foregroundColor(.white)
        }
    }
}

struct YinYangBallView: View {
    var body: some View {
        ZStack{
            BallView()
                .overlay{
                    Circle()
                        .stroke()
                        .foregroundColor(.primary)
                }
                .allowsHitTesting(false)
            Image("yinyang")
                .resizable()
                .frame(width: 48, height: 48)
        }
    }
}

struct BlackBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 48)
                .foregroundColor(.black)
            Circle()
                .strokeBorder(Color.white,lineWidth: 1.5)
                .frame(width: 46, height: 46)
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
            Circle()
                .frame(width: 47)
                .foregroundColor(.black)
            Text("🤣")
                .font(.system(size: 49))
                .offset(x:0.4)
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


struct CharactersDesignsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDesignsView()
    }
}
