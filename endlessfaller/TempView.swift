//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct Person {
    let name: String
    let cost: Int
    let character: any View
}


struct TempView: View {
    @State private var highlightedBox: Int = 0

    let people: [Person] = [
        Person(name: "John", cost: 25, character: BallView()),
        Person(name: "Emily", cost: 32, character: BallView()),
        Person(name: "Michael", cost: 40, character: BallView()),
        Person(name: "Sarah", cost: 28, character: BallView()),
        Person(name: "David", cost: 36, character: BallView()),
        Person(name: "Olivia", cost: 31, character: BallView()),
        Person(name: "Daniel", cost: 42, character: BallView()),
        Person(name: "Sophia", cost: 27, character: BallView()),
        Person(name: "James", cost: 33, character: BallView())
    ]

    var body: some View {
        VStack(spacing: 20) {
            ForEach(0..<people.count/3, id: \.self) { rowIndex in
                HStack(spacing: 20) {
                    ForEach(0..<3, id: \.self) { columnIndex in
                        let index = rowIndex * 3 + columnIndex
                        if index < people.count {
                            let person = people[index]
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .cornerRadius(20)
                                .frame(width: 100, height: 100)
                                .onTapGesture {
                                    highlightedBox = index
                                }
                                .overlay(
                                    ZStack{
                                        VStack(spacing: 4) {
                                            AnyView(person.character)
                                            Text("Age: \(person.cost)")
                                            
                                        }
                                        RoundedRectangle(cornerRadius: 20)
                                        .stroke(index == highlightedBox ? Color.primary : Color.clear, lineWidth: 2)
                                    }
                                )
                        }
                    }
                }
            }
        }
        .padding()
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
