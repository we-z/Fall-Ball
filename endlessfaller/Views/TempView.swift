//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine

struct TempView: View {
    @StateObject var userPersistedData = UserPersistedData()
    var body: some View {
        Form {
//            Toggle("Ready", isOn: $settings.readyForAction)
//                .toggleStyle(.switch)
//            TextField("Speed",value: $settings.speed,format: .number)
            Button{
                userPersistedData.incrementBalance(amount: 1)
            } label: {
                Text(String(userPersistedData.boinBalance))
            }
        }
        .frame(width: 400, height: 400)
    }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
