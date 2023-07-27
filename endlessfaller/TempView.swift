//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import StoreKit


struct TempView: View {
    let date = Date()
    let formatter = DateFormatter()
    @State var dateString = ""
    var body: some View {
        VStack(alignment: .leading) {
            Text(dateString)
                .bold()
        }
        
        
        .onAppear{
            formatter.dateFormat = "HH:mm:ss.SSS"
            dateString = formatter.string(from: date)
        }
    }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
