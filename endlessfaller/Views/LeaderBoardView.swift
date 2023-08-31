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
                Text("🏆 Leader Board 🏆")
                    .bold()
                    .italic()
                    .font(.largeTitle)
                    .scaleEffect(1.2)
            }
            if CKVM.scores.isEmpty{
                Spacer()
                ProgressView()
                    .scaleEffect(2)
                Spacer()
            } else {
                ScrollView(showsIndicators: false){
                    ForEach(Array(CKVM.scores.enumerated()), id: \.1.self) { index, score in
                        if let character = model.characters.first(where: { $0.characterID == score.characterID }){
                            let place = index + 1
                            VStack{
                                HStack{
                                    if place == 1 {
                                        Text("🥇 ")
                                            .padding(.leading)
                                            .font(.largeTitle)
                                            .scaleEffect(1.5)
                                    } else if place == 2 {
                                        Text("🥈 ")
                                            .font(.largeTitle)
                                            .padding(.leading)
                                            .scaleEffect(1.5)
                                    } else if place == 3 {
                                        Text("🥉 ")
                                            .font(.largeTitle)
                                            .padding(.leading)
                                            .scaleEffect(1.5)
                                    } else {
                                        Text("#" + String(place) + ":")
                                            .bold()
                                            .font(.title)
                                            .padding(.leading)
                                    }
                                    AnyView(character.character)
                                        .scaleEffect(1.2)
                                        .padding(.horizontal)
                                        .frame(width: 95)
                                    Spacer()
                                    Text(String(score.bestScore))
                                        .bold()
                                        .italic()
                                        .font(.largeTitle)
                                        .scaleEffect(1.2)
                                        .padding(.trailing, 30)
                                }
                            }
                            .frame(height: 100)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(score.record.recordID == recordID ? Color.primary : .clear, lineWidth: 3)
                            )
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .refreshable {
                    CKVM.fetchItems()
                }
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
