//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import Combine
import SwiftData


struct TempView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [UserData]
    @State private var input: String = ""
        
        
        var body: some View {
            VStack {
//                HStack {
//                    TextField("Add a task", text: $input )
//                    Button("Add") {
//                        let task = UserData(name: input)
//                        if !task.name.isEmpty{
//                            modelContext.insert(task)
//                            input = ""
//                        }
//                    }
//                }.padding()
//                
//                List{
//                    ForEach (items) { item in
//                        Text(item.name ?? "")
//                    }
//                }
            }
            .padding()
        }
}


struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
