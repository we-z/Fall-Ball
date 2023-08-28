//
//  LeaderBoardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/10/23.
//

import SwiftUI
import CloudKit

struct LeaderBoardView: View {
    @StateObject var model = AppModel()
    @StateObject private var CKVM = CloudKitCrud()
    @State var place = 1
    @State var recordID: CKRecord.ID? = nil
    var body: some View {
        VStack{
            HStack{
                Text("Score Board")
                    .bold()
                    .italic()
                    .font(.system(size:UIScreen.main.bounds.width/10))
            }
            Divider()
                .overlay(.primary)
                .padding(.horizontal)
            ScrollView(showsIndicators: false){
                ForEach(Array(CKVM.scores.enumerated()), id: \.1.self) { index, score in
                    if let character = model.characters.first(where: { $0.characterID == score.characterID }){
                        let place = index + 1
                        VStack{
                            HStack{
                                Text("#" + String(place))
                                    .bold()
                                    .font(.title)
                                    .padding(.leading)
                                AnyView(character.character)
                                    .scaleEffect(1.2)
                                    .padding(.horizontal)
                                    .frame(width: 75)
                                if place == 1 {
                                    Text("🥇")
                                        .font(.largeTitle)
                                } else if place == 2 {
                                    Text("🥈")
                                        .font(.largeTitle)
                                } else if place == 3 {
                                    Text("🥉")
                                        .font(.largeTitle)
                                }
                                Spacer()
                                Text(String(score.bestScore))
                                    .bold()
                                    .italic()
                                    .font(.system(size:UIScreen.main.bounds.width/12))
                                    .padding(.trailing, 30)
                            }
                            //                    Divider()
                            //                        .overlay(.gray)
                            //                        .padding(.horizontal)
                        }
                        .frame(height: 100)
                        .background(score.record.recordID == recordID ? Color.gray.opacity(0.2) : .clear)
                        .cornerRadius(20)
                        .padding(.horizontal)
                    }
                }
            }
            .refreshable {
                CKVM.fetchItems()
            }
        }
        .padding(.top, 30)
        .onAppear{
            if let localRecord = loadLocalRecord() {
                recordID = localRecord.recordID
            }
        }
    }
}

struct LeaderBoardView_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardView()
    }
}
