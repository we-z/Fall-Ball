//
//  SecretShopView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/9/23.
//

import SwiftUI

struct SecretShopView: View {
    @StateObject var model = AppModel()
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
                    Text("🎩 Hat Shop 🎩")
                        .italic()
                        .bold()
                        .font(.largeTitle)
                        .scaleEffect(1.1)
                }
                HStack{
                    Spacer()
                    ScrollView(showsIndicators: false){
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
                                                        .stroke(model.hats[index].hatID == model.selectedHat ? Color.primary : Color.clear, lineWidth: 3)
                                                        .padding(1)
                                                }
                                                .overlay(
                                                    ZStack{
                                                        AnyView(character?.character)
                                                            .scaleEffect(1.5)
                                                        AnyView(hat.hat)
                                                                
                                                    }
                                                    .padding()
                                                    .offset(y:12)
                                                )
                                                .accentColor(.primary)
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
