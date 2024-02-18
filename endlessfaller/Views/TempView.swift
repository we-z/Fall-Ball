//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    var body: some View {
        Text(UIDevice.current.hasDynamicIsland ? "Has Dynamic Island" : "Does Not Have Dynamic Island")
    }

}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
