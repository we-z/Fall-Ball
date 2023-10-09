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
        var body: some View {
            ZStack{
                ScrollView {
                    VStack {
                        ForEach(0..<200) { i in
                            HStack{
                                Text("Item \(i)").padding()
                                Spacer()
                                Text("Item \(i)").padding()
                                
                            }
                        }
                        Text("Bottom").padding()
                    }.background(GeometryReader { proxy -> Color in
                        DispatchQueue.main.async {
                            offset = -proxy.frame(in: .global).maxY
                        }
                        return Color.clear
                    })
                }
                Text("\(offset)")
                
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
