//
//  LeaderBoardDataManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/28/23.
//

//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CloudKit
import Combine

struct LeaderBoardDataManager: View {
    @StateObject private var vm = CloudKitCrud()
    
    private var header: some View {
        Text("CloudKit CRUD")
            .font(.largeTitle)
            .underline()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                header
                
                List {
                    ForEach(vm.scores, id: \.self) { score in
                        HStack {
                            Text(score.characterID)
                            Spacer()
                            Text(String(score.bestScore))
                        }
                        .onTapGesture {
                            vm.updateRecord(newScore: 333, newCharacterID: "Tester")
                            print("Record:")
                            print(score.record)
                        }
                    }
                    .onDelete(perform: vm.deleteItem)
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    vm.fetchItems()
                }
            }
            .padding()
            .navigationBarHidden(true)
        }
    }
}

struct LeaderBoardDataManager_Previews: PreviewProvider {
    static var previews: some View {
        LeaderBoardDataManager()
    }
}
