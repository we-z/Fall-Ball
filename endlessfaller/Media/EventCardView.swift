//
//  EventCardView.swift
//  Fall Ball
//
//  Created by Wheezy Capowdis on 7/12/24.
//

import SwiftUI

struct EventCardView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.red,.teal,.purple,.purple]), startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0))
            ZStack{
                RotatingSunView()
                HStack{
                    YellowDemonView()
                    PinkDemonView()
                        .offset(y: -20)
                    TealDemonView()
                }
                .scaleEffect(2.1)
                .offset(y: -120)
            }
            .offset(y:200)
        }
    }
}

#Preview {
    EventCardView()
}
