//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import VTabView
import QuartzCore


struct TempView: View {
    @State private var offset = CGFloat.zero
    @State private var showingAlert = false
        var body: some View {
            Button("Show Alert") {
                        showingAlert = true
                    }
                    .alert("Fall Ball uploads your scores to Game Center", isPresented: $showingAlert) {
                        Button("OK", role: .cancel) { }
                    }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
