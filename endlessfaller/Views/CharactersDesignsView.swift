//
//  CharactersDesignsView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/16/23.
//

import SwiftUI

struct CharactersDesignsView: View {
    var body: some View {
        VStack(spacing: 0){
            HStack{
                UnicornView()
                EarthBallView()
                BeachBallView()
            }
            Spacer()
        }
    }
}
struct EyesView: View {
    var body: some View {
//        Text("👀")
//            .scaleEffect(1.2)
//            .offset(y: -6)
        
//        HStack(spacing: 3){
//            ZStack{
//                Capsule()
//                    .frame(width: 15, height: 13)
//                    .foregroundColor(.black)
//                Capsule()
//                    .frame(width: 12, height: 10)
//                    .foregroundColor(.white)
//            }
//            ZStack{
//                Capsule()
//                    .frame(width: 15, height: 13)
//                    .foregroundColor(.black)
//                Capsule()
//                    .frame(width: 12, height: 10)
//                    .foregroundColor(.white)
//            }
//        }
//        .offset(y: -3)
        
        HStack {
            Circle()
                .foregroundColor(.black)
                .frame(width: 12)
                .overlay{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 9)
                        .offset(x: -3, y:-3)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 3)
                        .offset(x: 2, y:2)
                    Circle()
                        .stroke(.black, lineWidth: 2)
                }
                .mask{
                    Circle()
                        .frame(width: 12)
                }
                
            Spacer()
                .frame(maxWidth: 7)
            Circle()
                .foregroundColor(.black)
                .frame(width: 12)
                .overlay{
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 9)
                        .offset(x: -3, y:-3)
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 3)
                        .offset(x: 2, y:2)
                    Circle()
                        .stroke(.black, lineWidth: 2)
                }
                .mask{
                    Circle()
                        .frame(width: 12)
                }

        }
        .offset(y:-3)
        
    }
}
struct BoinsView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 36, height: 36)
                .foregroundColor(.black)
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(.orange)
            Circle()
                .stroke(lineWidth: 3)
                .frame(width: 30, height: 30)
                .foregroundColor(.yellow)
            Text("B")
                .bold()
                .italic()
                .foregroundColor(.yellow)
                .shadow(radius: 1)
                .font(.title2)
        }
    }
}


struct ObamaView: View {
    var body: some View {
        Image("obama-ball")
            .resizable()
            .frame(width: 46, height: 46)
            .scaleEffect(2)
            .mask(
                Circle()
                    .frame(width: 46)
            )
        
    }
}

struct DjkhaledView: View {
    var body: some View {
        Image("djkhaledface")
            .resizable()
            .frame(width: 48, height: 46)
            .scaleEffect(1.1)
            .offset(x:0.4, y:-0.1)
            .mask(
                Circle()
                    .frame(width: 46)
            )
    }
}

struct YeatView: View {
    var body: some View {
        Image("yeatface")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
    }
}

struct AllmightView: View {
    var body: some View {
        Image("allmight")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
    }
}

struct OnepieceView: View {
    var body: some View {
        Image("onepiece")
            .resizable()
            .frame(width: 46, height: 46)
            .scaleEffect(1.1)
    }
}

struct JoeRoganView: View {
    var body: some View {
        Image("joerogan")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
        
    }
}

struct SoccerBall: View {
    var body: some View {
        Text("⚽️")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct DiscoBall: View {
    var body: some View {
        Text("🪩")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct VolleyBall: View {
    var body: some View {
        Text("🏐")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct TennisBall: View {
    var body: some View {
        Text("🎾")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct BasketBall: View {
    var body: some View {
        Text("🏀")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct PoolBall: View {
    var body: some View {
        Text("🎱")
            .font(.system(size: 48))
            .offset(x:-1)
            .frame(width: 50, height: 50)
    }
}

struct FallBallLaughBall: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 46, height: 46)
                .mask(
                    Circle()
                        .frame(width: 46)
                )
                .overlay{
                    Circle()
                        .stroke(.black, lineWidth: 2)
                }
            HStack {
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 21, height: 18)
                            .offset(y:6.5)
                    }
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Circle()
                            .foregroundColor(.yellow)
                            .frame(width: 18, height: 18)
                            .offset(y:6.5)
                    }
            }
            .offset(y:0)
            Circle()
                .background(.white)
                .foregroundColor(.pink.opacity(0.6))
                .mask{
                    Rectangle()
                        .frame(height: 14)
                        .offset(y:10)
                }
                .frame(width: 33)
                .overlay{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 18, height: 6)
                        .roundedCorner(9, corners: [.bottomLeft, .bottomRight])
                        .offset(y:6)
                }
                .mask{
                    Circle()
                        .frame(width: 33)
                }
                .offset(y:3)
        }
        .frame(width: 46, height: 46)
    }
}

struct EvilBall: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.purple)
                .frame(width: 46, height: 46)
                .mask(
                    Circle()
                        .frame(width: 46)
                )
            Circle()
                .foregroundColor(.black)
                .frame(width: 30)
                .overlay{
                    Circle()
                        .foregroundColor(.purple)
                        .frame(width: 60, height: 60)
                        .offset(y:-21)
                }
                .offset(y:2)
            HStack {
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Rectangle()
                            .foregroundColor(.purple)
                            .frame(width: 13, height: 7)
                            .offset(y:-4)
                    }
                    .rotationEffect(.degrees(15))
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Rectangle()
                            .foregroundColor(.purple)
                            .frame(width: 13, height: 7)
                            .offset(y:-4)
                    }
                    .rotationEffect(.degrees(-15))
            }
            .offset(y:-2)
            
        }
        .mask(
            Circle()
                .frame(width: 46)
        )
        .background{
            ZStack{
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 50, height: 50)
                Circle()
                    .foregroundColor(.purple.opacity(0.5))
                    .frame(width: 50, height: 50)
                Circle()    // source
                    .frame(width: 90, height: 90)
                    .blendMode(.destinationOut)
                    .offset(y: -40)
                    .allowsHitTesting(false)
            }
            .compositingGroup()
            .offset(y:-21)
//            .overlay(
//                Circle()
//                    .foregroundColor(.teal)
//                    .frame(width: 180)
//                    .offset(y:-9)
//            )
        }
        
        .frame(width: 46, height: 46)
    }
}

struct ShockedBall: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.yellow)
                .frame(width: 46, height: 46)
                .mask(
                    Circle()
                        .frame(width: 46)
                )
                .overlay{
                    Circle()
                        .stroke(.black, lineWidth: 2)
                }
            HStack {
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 9)
                            .offset(x: -3, y:-3)
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 3)
                            .offset(x: 2, y:2)
                        Circle()
                            .stroke(.black, lineWidth: 2)
                    }
                    .mask{
                        Circle()
                            .frame(width: 12)
                    }
                    
                Spacer()
                    .frame(maxWidth: 9)
                Circle()
                    .foregroundColor(.black)
                    .frame(width: 12)
                    .overlay{
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 9)
                            .offset(x: -3, y:-3)
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 3)
                            .offset(x: 2, y:2)
                        Circle()
                            .stroke(.black, lineWidth: 2)
                    }
                    .mask{
                        Circle()
                            .frame(width: 12)
                    }

            }
            .offset(y:-1)
            Circle()
                .background(.white)
                .foregroundColor(.pink.opacity(0.6))
                .frame(width: 12)
                .overlay{
                    Rectangle()
                        .foregroundColor(.white)
                        .frame(width: 18, height: 6)
                        .roundedCorner(9, corners: [.bottomLeft, .bottomRight])
                        .offset(y:-5)
                }
                .mask{
                    Circle()
                        .frame(width: 33)
                }
                .offset(y:12)
        }
        .frame(width: 46, height: 46)
    }
}

struct IceSpiceView: View {
    var body: some View {
        Image("icespice")
            .resizable()
            .frame(width: 46, height: 46)
            .scaleEffect(1.1)
            .offset(x: -1)
            .mask(
                Circle()
                    .frame(width: 46)
            )
            
    }
}

struct RickView: View {
    var body: some View {
        Image("rick")
            .resizable()
            .frame(width: 46, height: 46)
            
    }
}

struct MortyView: View {
    var body: some View {
        Image("morty")
            .resizable()
            .frame(width: 46, height: 46)
            
    }
}

struct AlbertView: View {
    var body: some View {
        Image("albertball")
            .resizable()
            .frame(width: 56, height: 46)
            
    }
}

struct MonkeyView: View {
    var body: some View {
        BallView()
            .overlay{
                Image("monkey")
                    .resizable()
                    .frame(width: 71, height: 79)
                    .mask(
                        Rectangle()
                            .frame(width: 69, height: 59)
                    )
                    .offset(x: -0.1, y: -0.4)
                    
            }
        
    }
}


struct KaiView: View {
    var body: some View {
        Image("kaiball")
            .resizable()
            .frame(width: 56, height: 48)
            
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
    }
}

struct RussiaView: View {
    var body: some View {
        BallView()
            .background(
                Image("russia")
                    .resizable()
                    .frame(width: 80, height: 46)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct SwedenView: View {
    var body: some View {
        BallView()
            .background(
                Image("sweden")
                    .resizable()
                    .frame(width: 80, height: 45)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct FinlandView: View {
    var body: some View {
        BallView()
            .background(
                Image("finland")
                    .resizable()
                    .frame(width: 80, height: 42)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct NorwayView: View {
    var body: some View {
        BallView()
            .background(
                Image("norway")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct DenmarkView: View {
    var body: some View {
        BallView()
            .background(
                Image("denmark")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct EstoniaView: View {
    var body: some View {
        BallView()
            .background(
                Image("estonia")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct ItalyView: View {
    var body: some View {
        BallView()
            .background(
                Image("italy")
                    .resizable()
                    .frame(width: 42, height: 42)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct GreeceView: View {
    var body: some View {
        BallView()
            .background(
                Image("greece")
                    .resizable()
                    .frame(width: 60, height: 42)
                    .offset(x:9)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct TurkeyView: View {
    var body: some View {
        BallView()
            .background(
                Image("turkey")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct UkraineView: View {
    var body: some View {
        BallView()
            .background(
                Image("ukraine")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct PolandView: View {
    var body: some View {
        BallView()
            .background(
                Image("poland")
                    .resizable()
                    .frame(width: 80, height: 50)
//                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct BelarusView: View {
    var body: some View {
        BallView()
            .background(
                Image("belarus")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .offset(x:18)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct SomaliaView: View {
    var body: some View {
        BallView()
            .background(
                Image("somalia")
                    .resizable()
                    .frame(width: 80, height: 50)
//                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct KenyaView: View {
    var body: some View {
        BallView()
            .background(
                Image("kenya")
                    .resizable()
                    .frame(width: 80, height: 50)
//                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct TanzaniaView: View {
    var body: some View {
        BallView()
            .background(
                Image("tanzania")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct ThailandView: View {
    var body: some View {
        BallView()
            .background(
                Image("thailand")
                    .resizable()
                    .frame(width: 80, height: 42)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct VietnamView: View {
    var body: some View {
        BallView()
            .background(
                Image("vietnam")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct MalaysiaView: View {
    var body: some View {
        BallView()
            .background(
                Image("malaysia")
                    .resizable()
                    .frame(width: 60, height: 42)
                    .offset(x:1)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct ChileView: View {
    var body: some View {
        BallView()
            .background(
                Image("chile")
                    .resizable()
                    .frame(width: 60, height: 42)
                    .offset(x:8)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct ArgentinaView: View {
    var body: some View {
        BallView()
            .background(
                Image("argentina")
                    .resizable()
                    .frame(width: 42, height: 42)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct PeruView: View {
    var body: some View {
        BallView()
            .background(
                Image("peru")
                    .resizable()
                    .frame(width: 60, height: 42)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct EgyptView: View {
    var body: some View {
        BallView()
            .background(
                Image("Egypt")
                    .resizable()
                    .frame(width: 80, height: 50)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct PalestineView: View {
    var body: some View {
        BallView()
            .background(
                Image("Palestine")
                    .resizable()
                    .frame(width: 90, height: 50)
                    .offset(x:18)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct MoroccoView: View {
    var body: some View {
        BallView()
            .background(
                Image("Morocco")
                    .resizable()
                    .frame(width: 130, height: 90)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct ChinaView: View {
    var body: some View {
        BallView()
            .background(
                Image("china")
                    .resizable()
                    .frame(width: 69, height: 44)
                    .offset(x:12, y: 0)
                    .mask(
                        Circle()
                            .frame(width: 46)
                    )
            )
    }
}

struct EarthBallView: View {
    var body: some View {
        ZStack{
            Text("🌍")
                .font(.system(size: 45))
            BallView()
        }
    }
}

struct BeachBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 46)
            Image("beachball")
                .resizable()
                .flipped(.horizontal)
                .frame(width: 45, height: 45)
                .mask(
                    Circle()
                        .frame(width: 42)
                )
        }
    }
}

struct UnicornView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 46)
            Image("unicorn")
                .resizable()
                .frame(width: 45, height: 43)
                .mask(
                    Circle()
                        .frame(width: 42)
                )
            Image("unicornhorn")
                .resizable()
                .frame(width: 12, height: 18)
                .offset(x:12,y: -16)
        }
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
            
    }
}

struct BallView: View {
    var body: some View {
        ZStack{
            Circle()
                .strokeBorder(Color.black,lineWidth: 2)
                .allowsHitTesting(false)
                .frame(width: 46, height: 46)
            EyesView()
        }
    }
}

struct WhiteBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 46)
                .foregroundColor(.black)
            Circle()
                .frame(width: 40)
                .foregroundColor(.white)
        }
    }
}

struct DiamondBallView: View {
    var body: some View {
        Image("diamond")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
            .overlay{
                Text("✨")
                    .scaleEffect(1.5)
                    .offset(x:15, y:-15)
                    .flashing()
            }
    }
}

struct GoldBallView: View {
    var body: some View {
        Image("goldenball")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
            .overlay{
                Text("✨")
                    .scaleEffect(1.5)
                    .offset(x:15, y:-15)
                    .flashing()
            }
    }
}

struct PearlBallView: View {
    var body: some View {
        Image("pearl")
            .resizable()
            .frame(width: 46, height: 46)
            .mask(
                Circle()
                    .frame(width: 46)
            )
            .overlay{
                Text("✨")
                    .scaleEffect(1.5)
                    .offset(x:15, y:-15)
                    .flashing()
            }
    }
}

struct OrbBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 46)
                .foregroundColor(.black)
            Circle()
                .frame(width: 42)
                .foregroundColor(.yellow)
                .overlay{
                    Text("🔮")
                        .scaleEffect(1.2)
                }
        }
    }
}

struct YinYangBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .foregroundColor(.black)
                .frame(width: 50, height: 50)
            Image("yinyang")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}

struct BlackBallView: View {
    var body: some View {
        ZStack{
            Circle()
                .frame(width: 46)
                .foregroundColor(.black)
            Circle()
                .strokeBorder(Color.white,lineWidth: 2)
                .frame(width: 44, height: 44)
        }
    }
}

struct BombBallView: View {
    var body: some View {
        ZStack{
            Text("💣")
                .font(.system(size: 51))
        }
        .frame(height: 46)
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
                        .frame(width: 44, height: 45)
                        .mask(
                            Circle()
                                .frame(width: 46, height: 46)
                        )
                }
            )
            
    }
}


struct CharactersDesignsView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersDesignsView()
    }
}
