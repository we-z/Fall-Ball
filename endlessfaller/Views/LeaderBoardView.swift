//
//  LeaderBoardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/10/23.
//

import SwiftUI
import CloudKit

let userNameKey = "myUserName"

struct LeaderBoardView: View {
    let deviceWidth = UIScreen.main.bounds.width
    @StateObject var model = AppModel()
    @StateObject private var CKVM = CloudKitCrud()
    @State var place = 1
    @State var unserNameTextField = ""
    @State var recordID: CKRecord.ID? = nil
    @AppStorage(userNameKey) var myUserName: String = (UserDefaults.standard.string(forKey: userNameKey) ?? "")
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @FocusState var isTextFieldFocused: Bool

    func writeUsernameToLeaderboard(userNameToWrite: String) {
        CKVM.addItem(characterID: model.selectedCharacter, score: bestScore, userName: userNameToWrite)
    }
    
    var body: some View {
        ZStack{
            Color.primary.opacity(0.03)
                .ignoresSafeArea()
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                HStack{
                    Text("🏆 LEADERBOARD 🏆")
                        .bold()
                        .font(.largeTitle)
                        .foregroundColor(.black)
                        .offset(y: 6)
                }
                if myUserName.isEmpty{
                    ZStack{
                        Spacer()
                        
                    }.overlay{
                        VStack{
                            HStack{
                                TextField("Username", text: $unserNameTextField, axis: .vertical)
                                    .textFieldStyle(.plain)
                                    .focused($isTextFieldFocused)
                                    .italic()
                                    .bold()
                                    .limitInputLength(value: $unserNameTextField, length: 15)
                                    .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now()) {
                                                isTextFieldFocused = true
                                            }
                                        }
                                Button{
                                    myUserName = unserNameTextField
                                    writeUsernameToLeaderboard(userNameToWrite: myUserName)
                                } label: {
                                    Image(systemName: "checkmark.circle")
                                        .foregroundColor(unserNameTextField.count < 4 ? .gray : .black)
                                }
                                .disabled(unserNameTextField.count < 3)
                            }
                            .font(.title2)
                            .padding(.vertical, 18)
                            .padding(.horizontal)
                            .background{
                                Color.white
                                    .cornerRadius(15)
                                    .shadow(radius: 2, x: 0,y: 2)
                            }
                            HStack{
                                Text("Your username must be between 3 and 15 characters in length.")
                                    .foregroundColor(.gray)
                                Spacer()
                            }
                        }
                        .padding()
                    }
                } else {
                    if CKVM.scores.isEmpty{
                        Spacer()
                        ProgressView()
                            .scaleEffect(2)
                        Spacer()
                    } else {
                        ScrollView(showsIndicators: false){
                            ForEach(Array(CKVM.scores.enumerated()), id: \.1.self) { index, score in
                                    let place = index + 1
                                    VStack{
                                        ZStack{
                                            HStack{
                                                if place == 1 {
                                                    Text("🥇 ")
                                                        .padding(.leading)
                                                        .font(.largeTitle)
                                                        .scaleEffect(1.5)
                                                        .offset(y: -9)
                                                } else if place == 2 {
                                                    Text("🥈 ")
                                                        .font(.largeTitle)
                                                        .padding(.leading)
                                                        .scaleEffect(1.5)
                                                        .offset(y: -9)
                                                } else if place == 3 {
                                                    Text("🥉 ")
                                                        .font(.largeTitle)
                                                        .padding(.leading)
                                                        .scaleEffect(1.5)
                                                        .offset(y: -9)
                                                } else {
                                                    Text(String(place) + ":")
                                                        .italic()
                                                        .bold()
                                                        .font(.title)
                                                        .foregroundColor(.black)
                                                        .frame(maxWidth: .infinity, alignment: .center)
                                                        .position(x: 33, y: 45)
                                                }
                                                Spacer()
                                            }
                                            .offset(x: deviceWidth * 0.19, y: -15)
                                            if let character = model.characters.first(where: { $0.characterID == score.characterID }){
                                                AnyView(character.character)
                                                    .padding(.horizontal)
                                                    .frame(width: 95)
                                                    .position(x: deviceWidth * 0.18, y: 50)
                                                    .scaleEffect(1.2)
                                            } else {
                                                Image(systemName: "questionmark.circle")
                                                    .font(.system(size: 55))
                                                    .position(x: deviceWidth * 0.12, y: 50)
                                            }
                                            Text(score.playerUserName)
                                                .bold()
                                                .italic()
                                                .font(.title3)
                                                .foregroundColor(.black)
                                                .offset(x: deviceWidth * 0.24, y: 21)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            Text(String(score.bestScore))
                                                .bold()
                                                .italic()
                                                .font(.largeTitle)
                                                .foregroundColor(.black)
                                                .position(x: deviceWidth - 80, y: 30)
                                                .frame(maxWidth: .infinity, alignment: .center)
                                        }
                                    }
                                    .frame(height: 100)
                                    .background(.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 2, y:2)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(score.record.recordID == recordID ? Color.black : .clear, lineWidth: 3)
                                    )
                                    .padding(.top, 6)
                                    .padding(.horizontal)
                            }
                            .padding(.top)
                        }
                        .refreshable {
                            CKVM.fetchItems()
                        }
                    }
                }
            }
        }
        .onAppear{
            //print("LeaderBoardView Appeared")
            CKVM.fetchItems()
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
