//
//  LeaderBoardView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 8/10/23.
//

import SwiftUI

struct LeaderBoardView: View {
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
