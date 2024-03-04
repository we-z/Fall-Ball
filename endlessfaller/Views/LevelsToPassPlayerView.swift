//
//  LevelsToPassPlayerView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 3/3/24.
//

import SwiftUI

struct LevelsToPassPlayerView: View {
    var body: some View {
        VStack{
            HStack{
                Spacer()
                VStack{
                    Text("69 to pass")
                        .bold()
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .top])
                    UnicornView()
                        .padding(.horizontal)
                    Text("Wheezy Capowdis")
                        .bold()
                        .italic()
                        .multilineTextAlignment(.center)
                        .padding([.horizontal, .bottom])
                }
                .background(Color.primary.opacity(0.1))
                .cornerRadius(21)
                .frame(maxWidth: 120)
                .padding()
                .padding(.top, 36)
            }
            Spacer()
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LevelsToPassPlayerView()
}
