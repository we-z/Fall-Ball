//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {

    var body: some View {
        ZStack{
            Color(hex: "283047")
            VStack{
                Text("I N A S   K A N D E E L")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                Text("F A S H I O N . B E A U T Y . S T O R I E S")
                    .foregroundColor(.white)
                    .font(.caption)
                
            }
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
