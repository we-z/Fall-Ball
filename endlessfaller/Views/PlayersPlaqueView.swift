//
//  PlayersPlaqueView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/5/23.
//

import SwiftUI
import GameKit
import FirebaseAuth
import FirebaseRemoteConfig

struct PlayersPlaqueView: View {
    @ObservedObject private var appModel = AppModel.sharedAppModel
    @Environment(\.displayScale) var displayScale
    @State private var sheetPresented : Bool = false
    @StateObject var userPersistedData = AppModel.sharedAppModel.userPersistedData
    @State private var referralURL: URL?
    
    @MainActor
    private func render() -> UIImage? {
        let renderer = ImageRenderer(content: plaqueView())
        renderer.scale = displayScale
        return renderer.uiImage
    }
    
    private func plaqueView () -> some View {
        
        ZStack{
            Rectangle()
                .overlay(RandomGradientView())
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: -30)
            VStack{
                Text("I Play Fall Ball As:")
                    .customTextStroke()
                    .bold()
                    .italic()
                if let character = appModel.characters.first(where: { $0.characterID == userPersistedData.selectedCharacter }) {
                    let hat = appModel.hats.first(where: { $0.hatID == userPersistedData.selectedHat })
                    let bag = appModel.bags.first(where: { $0.bagID == userPersistedData.selectedBag })
                    ZStack{
                        if userPersistedData.selectedBag != "nobag" {
                            AnyView(bag!.bag)
                                .frame(maxWidth: 180, maxHeight: 60)
                        }
                        AnyView(character.character)
                            .scaleEffect(1.5)
                        if userPersistedData.selectedHat != "nohat" {
                            AnyView(hat!.hat)
                                .frame(maxWidth: 60, maxHeight: 60)
                        }
                    }
                    .padding(.top, 30)
                    .padding(.bottom, 39)
                    .scaleEffect(1.2)
                    .offset(y:20)
                }
                
                Text(GKLocalPlayer.local.isAuthenticated ? GKLocalPlayer.local.displayName : "Unknown Player")
                    .customTextStroke(width: 1.5)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
                    .bold()
                    .italic()
                    .font(.title)
                Text("Beat My Top Score: \(userPersistedData.bestScore)")
                    .customTextStroke()
                    .font(.caption)
                    .bold()
                    .italic()
                    .padding(9)
                    .background(.black.opacity(0.1))
                    .cornerRadius(6)
            }
        }
        .frame(width: 330, height: 330)
    }
    
    var body: some View {
        ZStack{
            RandomGradientView()
                .overlay(.black.opacity(0.6))
            VStack{
                plaqueView()
                    .cornerRadius(30)
                Button(action: {
                    
                    withAnimation{
                   
                        self.sheetPresented = true
                       
                    }
                        
                }){
                    HStack{
                        Image(systemName: "square.and.arrow.up")
                        Text("Share")
                            .bold()
                            .italic()
                    }
                    .customTextStroke()
                    .padding(9)
                    .padding(.horizontal, 6)
                    .background(RandomGradientView())
                    .cornerRadius(30)
                    .padding(30)
                }
            }
        }
        .sheet(isPresented: $sheetPresented, content: {
            let referralMessage = RemoteConfig.remoteConfig().configValue(forKey: "referral_message").stringValue
            if let data = render() {
                ShareView(activityItems: [data, "\(referralMessage ?? "") \n\n\(referralURL)"])
            }
        })
        .onAppear(perform: {
            Task {
                if let user = Auth.auth().currentUser {
                    self.referralURL = await user.makeReferralLinkAsync()
                }
            }
        })
        .ignoresSafeArea()
    }
}

#Preview {
    PlayersPlaqueView()
}
