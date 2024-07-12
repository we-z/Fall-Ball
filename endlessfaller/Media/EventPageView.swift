//
//  EventPageView.swift
//  Fall Ball
//
//  Created by Wheezy Capowdis on 7/12/24.
//

import SwiftUI

struct EventPageView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.teal,.teal,.purple]), startPoint: UnitPoint(x: 0, y: 1), endPoint: UnitPoint(x: 1, y: 0))
            ZStack{
                RotatingSunView()
                VStack{
                    YellowDemonView()
                    PinkDemonView()
                    TealDemonView()
                }
                .scaleEffect(2.1)
            }
            .offset(y: -210)
        }
    }
}

#Preview {
    EventPageView()
}
