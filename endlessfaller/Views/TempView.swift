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
    let colors: [Color] = [.red, .green, .blue, .orange, .indigo, .purple]
    @State private var selectedIndex: Int?

    var body: some View {
        VStack(alignment: .center) {
            ScrollViewReader { value in
                Button ("Move to #8") {
                    withAnimation {
                        value.scrollTo(8)
                        selectedIndex = 8
                    }
                }
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        ForEach(0...50, id: \.self) { index in
                            Text("Item \(index)")
                                .font(.title)
                                .foregroundStyle(.white)
                                .frame(width: height(index: index), height: height(index: index)) // frame for selected
                                .background(colors[index % colors.count])
                                .cornerRadius(8)
                                .id(index)
                                .onTapGesture {
                                    withAnimation {
                                        selectedIndex = index
                                        value.scrollTo(index)
                                    }
                                }
                        }
                    }
                }.frame(height: 150)
                .padding()
            }
        }
    }
    
    func height(index: Int) -> CGFloat {
        return selectedIndex == index ? 120 : 100
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
