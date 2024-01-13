//
//  SecretShopView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/9/23.
//

import SwiftUI

struct SecretShopView: View {
    @ObservedObject private var model = AppModel.sharedAppModel
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        GeometryReader { geometry in
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                HStack{
                    Text("🤫 Secret Shop 🤫")
                        .italic()
                        .bold()
                        .font(.largeTitle)
                }
                Divider()
                    .overlay(.black)
                    .padding([.horizontal])
                HStack{
                    Spacer()
                    ScrollView(showsIndicators: false){
                        HStack{
                            Text("🎩 Hats 🎩")
                                .italic()
                                .bold()
                                .font(.largeTitle)
                        }
                        ForEach(0..<model.hats.count/3, id: \.self) { rowIndex in
                            HStack {
                                ForEach(0..<3, id: \.self) { columnIndex in
                                    let index = rowIndex * 3 + columnIndex
                                    if index < model.hats.count {
                                        let character = model.characters.first(where: { $0.characterID == model.selectedCharacter})
                                        let hat = model.hats[index]
                                        Button {
                                            model.selectedHat = model.hats[index].hatID
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .cornerRadius(20)
                                                .frame(width: geometry.size.width/3.3, height: idiom == .pad ? 270 : 150)
                                                .overlay{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(model.hats[index].hatID == model.selectedHat ? Color.black : Color.clear, lineWidth: 3)
                                                        .padding(1)
                                                }
                                                .overlay(
                                                    ZStack{
                                                        if model.hats[index].hatID == model.selectedHat && index != 0 {
                                                            AnyView(character?.character)
                                                                .scaleEffect(1.5)
                                                        }
                                                        AnyView(hat.hat)
                                                            .offset(y: model.hats[index].hatID == model.selectedHat ? 0 : 30)
                                                                
                                                    }
                                                    .padding()
                                                    .offset(y: index == 0 ? 0 : 12)
                                                )
                                                .accentColor(.black)
                                                .padding(1)
                                        }
                                        .buttonStyle(.roundedAndShadow)
                                        
                                    }
                                }
                            }
                        }
                        HStack{
                            Text("🎒 Bags 🎒")
                                .italic()
                                .bold()
                                .font(.largeTitle)
                        }
                        ForEach(0..<model.bags.count/2, id: \.self) { rowIndex in
                            HStack {
                                ForEach(0..<2, id: \.self) { columnIndex in
                                    let index = rowIndex * 2 + columnIndex
                                    if index < model.bags.count {
                                        let character = model.characters.first(where: { $0.characterID == model.selectedCharacter})
                                        let bag = model.bags[index]
                                        Button {
                                            model.selectedBag = model.bags[index].bagID
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .cornerRadius(20)
                                                .frame(width: geometry.size.width/2.2, height: idiom == .pad ? 270 : 150)
                                                .overlay{
                                                    RoundedRectangle(cornerRadius: 20)
                                                        .stroke(model.bags[index].bagID == model.selectedBag ? Color.black : Color.clear, lineWidth: 3)
                                                        .padding(1)
                                                }
                                                .overlay(
                                                    ZStack{
                                                        AnyView(bag.bag)
                                                        if model.bags[index].bagID == model.selectedBag && index != 0 {
                                                            AnyView(character?.character)
                                                                .scaleEffect(1.5)
                                                        }
                                                    }
                                                )
                                                .accentColor(.black)
                                                .padding(1)
                                        }
                                        .buttonStyle(.roundedAndShadow)
                                        
                                    }
                                }
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    SecretShopView()
}
