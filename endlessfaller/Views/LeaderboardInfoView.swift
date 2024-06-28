//
//  LeaderboardInfoView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/17/24.
//

import SwiftUI

struct LeaderboardInfoView: View {
    var body: some View {
        ZStack{
            RotatingSunView()
            VStack{
                Text("Fall Ball uses Game\nCenter Leaderboards")
                    .bold()
                    .italic()
                    .font(.system(size: 27))
                    .multilineTextAlignment(.center)
                    .padding()
                Text("Sign into Game Center via:\nSettings App > Game Center")
                    .bold()
                    .italic()
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .customTextStroke(width: 1.5)
        }
        .frame(width: 300, height: 300)
        .background(RandomGradientView())
        .cornerRadius(30)
    }
}

#Preview {
    LeaderboardInfoView()
}
