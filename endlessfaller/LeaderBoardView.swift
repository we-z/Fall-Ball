//
//  LeaderBoardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/10/23.
//

import SwiftUI

struct LeaderBoardView: View {
//    @StateObject var model = AppModel()
//    @State var place = 1
//    var body: some View {
//        ScrollView(showsIndicators: false){
//            HStack{
//                Text("Score Board")
//                    .bold()
//                    .italic()
//                    .font(.system(size:UIScreen.main.bounds.width/10))
//            }
//            Divider()
//                .overlay(.gray)
//                .padding(.horizontal)
//            ForEach((0..<model.characters.count).reversed(), id: \.self) { index in
//                let character = model.characters[index]
//                let place = model.characters.count - index
//                VStack{
//                    HStack{
//                        Text("#" + String(place))
//                            .bold()
//                            .font(.title)
//                            .padding(.leading)
//                        AnyView(character.character)
//                            .scaleEffect(1.2)
//                            .padding()
//                        if place == 1 {
//                            Text("🥇")
//                                .font(.largeTitle)
//                        } else if place == 2 {
//                            Text("🥈")
//                                .font(.largeTitle)
//                        } else if place == 3 {
//                            Text("🥉")
//                                .font(.largeTitle)
//                        }
//                        Spacer()
//                        Text("1000")
//                            .bold()
//                            .italic()
//                            .font(.system(size:UIScreen.main.bounds.width/12))
//                            .padding(.trailing, 30)
//                    }
//                    Divider()
//                        .overlay(.gray)
//                        .padding(.horizontal)
//                }
//            }
//        }
//        .padding(.top, 30)
//    }
    
    var body: some View {
        VStack{
            Text("Leader Board comming soon")

                .bold()
                .italic()
                .multilineTextAlignment(.center)
            Image(systemName: "clock")
                .padding(1)
        }
        .font(.largeTitle)
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
