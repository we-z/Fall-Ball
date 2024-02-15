//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine
import CircularProgress


struct TempView: View {
    @State var progress = CircularProgressState.inProgress(0)
        
    var body: some View {
        VStack{
            CircularProgress(lineWidth: 12, state: progress)
                .onTimer {
                    progress = if progress.rawValue + 0.02 >= 1 { .succeeded }
                    else { .inProgress(progress.rawValue + 0.02) }
                    
                }
                .frame(width: 60)
                .rotationEffect(.degrees(-90))
            Button{
                self.progress = CircularProgressState.inProgress(0)
            } label: {
                Text("Reset")
            }
        }
        
    }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
