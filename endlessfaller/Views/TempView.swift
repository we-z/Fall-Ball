//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    @State private var title: String = ""
        @State private var category: String = ""
        @State private var type: String = ""
        
        var body: some View {
            VStack {
                Text("DevTechie Courses")
                    .font(.largeTitle)
                
                VStack(alignment: .leading) {
                    Text("Enter new course title")
                        .font(.title3)
                    
                    TextField("Course title", text: $title)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.orange)
                        )
                        .foregroundColor(Color.green)
                        
                    TextField("Course category", text: $category)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.teal)
                        )
                        .foregroundColor(Color.blue)
                        
                    TextField("Course type", text: $type)
                        .padding(5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.pink)
                        )
                        .foregroundColor(Color.purple)
                    
                }.padding(.top, 20)
            }.padding()
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
