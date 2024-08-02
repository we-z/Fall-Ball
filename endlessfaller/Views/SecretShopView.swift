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
    @StateObject var userPersistedData = UserPersistedData()
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            VStack{
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                HStack{
                    Text("🤫 Secret Shop 🤫")
                        .customTextStroke(width: 2.1)
                        .italic()
                        .bold()
                        .font(.system(size: 36))
                }
                Divider()
                    .frame(height: 3)
                    .overlay(.black)
                    .padding([.horizontal])
                HStack{
                    Spacer()
                    ScrollView(showsIndicators: false){
                        ForEach(0..<model.hats.count/3, id: \.self) { rowIndex in
                            HStack {
                                Spacer()
                                ForEach(0..<3, id: \.self) { columnIndex in
                                    let index = rowIndex * 3 + columnIndex
                                    if index < model.hats.count {
                                        let character = model.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter})
                                        let hat = model.hats[index]
                                        Button {
                                            userPersistedData.selectNewHat(hat:model.hats[index].hatID)
                                        } label: {
                                            Rectangle()
                                                .fill(.clear)
                                                .cornerRadius(20)
                                                .frame(width: idiom == .pad ? deviceWidth / 4.8 : deviceWidth / 3.3, height: idiom == .pad ? 270 : 150)
                                                .background(RandomGradientView())
                                                .cornerRadius(20)
                                                .overlay{
                                                    if model.hats[index].hatID == userPersistedData.selectedHat {
                                                        RoundedRectangle(cornerRadius: 20)
                                                            .stroke(Color.black, lineWidth: 6)
                                                    }
                                                }
                                                .overlay{
                                                    ZStack{
                                                        if model.hats[index].hatID == userPersistedData.selectedHat && index != 0 {
                                                            AnyView(character?.character)
                                                                .scaleEffect(1.5)
                                                        }
                                                        AnyView(hat.hat)
                                                            .offset(y: model.hats[index].hatID == userPersistedData.selectedHat ? 0 : index == 0 ? 0 : 30)
                                                        
                                                    }
                                                    .padding()
                                                    .offset(y: index == 0 ? 0 : 12)
                                                    
                                                }
                                                .accentColor(.black)
                                                .padding(1)
                                        }
                                        .buttonStyle(.characterMenu)
                                        
                                    }
                                }
                                Spacer()
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
