//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine

class SharedData: ObservableObject {
    @Published var data: String

    // Singleton instance
    static let shared = SharedData()

    private init(data: String = "Initial Data") {
        self.data = data
    }
}

struct View1: View {
    @ObservedObject var sharedData = SharedData.shared
    var body: some View {
        VStack {
            Text("View 1: \(sharedData.data)")
            Button("Update from View 1") {
                sharedData.data = "Updated by View 1"
            }
        }
    }
}

struct View2: View {
    @ObservedObject private var sharedData = SharedData.shared
    var body: some View {
        VStack {
            Text("View 2: \(sharedData.data)")
            Button("Update from View 2") {
                sharedData.data = "Updated by View 2"
            }
        }
    }
}

struct TempView: View {
        var body: some View {
            VStack {
                View1()
                View2()
            }
        }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
