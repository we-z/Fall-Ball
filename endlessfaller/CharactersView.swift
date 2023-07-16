//
//  CharactersView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/15/23.
//

import SwiftUI

struct CharactersView: View {
    var body: some View {
        ScrollView{
            VStack{
                HStack{
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .colorInvert()
                                .frame(height: 46)
                            Spacer()
                            Text("Free")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .frame(height: 46)
                            Spacer()
                            Text("$2.99")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.orange)
                                .frame(height: 46)
                            Spacer()
                            Text("$2.99")
                                .bold()
                        }
                        .padding()
                    }
                }
                HStack{
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.blue)
                                .frame(height: 46)
                            Spacer()
                            Text("$4.99")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.red)
                                .frame(height: 46)
                            Spacer()
                            Text("$4.99")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.green)
                                .frame(height: 46)
                            Spacer()
                            Text("$4.99")
                                .bold()
                        }
                        .padding()
                    }
                }
                HStack{
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.purple)
                                .frame(height: 46)
                            Spacer()
                            Text("$9.99")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.cyan)
                                .frame(height: 46)
                            Spacer()
                            Text("$9.99")
                                .bold()
                        }
                        .padding()
                    }
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .opacity(0.1)
                            .frame(width: UIScreen.main.bounds.width/3.3, height: UIScreen.main.bounds.width/3.3)
                        VStack{
                            Circle()
                                .foregroundColor(.yellow)
                                .frame(height: 46)
                            Spacer()
                            Text("$9.99")
                                .bold()
                        }
                        .padding()
                    }
                }
            }
        }
        .padding(.top, 30)
    }
}

struct CharactersView_Previews: PreviewProvider {
    static var previews: some View {
        CharactersView()
    }
}
