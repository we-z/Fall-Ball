//
//  PlayersPlaqueView.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 10/5/23.
//

import SwiftUI
import GameKit

struct PlayersPlaqueView: View {
    @StateObject var appModel = AppModel()
    @AppStorage(bestScoreKey) var bestScore: Int = UserDefaults.standard.integer(forKey: bestScoreKey)
    @Binding  var backgroundColor: Color
    @Environment(\.displayScale) var displayScale
    @State private var sheetPresented : Bool = false
    
    @MainActor
    private func render() -> UIImage?{
        
        let renderer = ImageRenderer(content: plaqueView())

        renderer.scale = displayScale
     
        return renderer.uiImage
    }
    
    
    private func plaqueView () -> some View {
        
        ZStack{
            Rectangle()
                .foregroundColor(backgroundColor)
                .frame(width: 330, height: 330)
            RotatingSunView()
                .offset(y: -30)
            VStack{
                Text("I play Fall Ball as:")
                    .bold()
                    .italic()
                if let character = appModel.characters.first(where: { $0.characterID == appModel.selectedCharacter}) {
                    let hat = appModel.hats.first(where: { $0.hatID == appModel.selectedHat})
                    ZStack{
                        AnyView(character.character)
                            .scaleEffect(1.5)
                        AnyView(hat!.hat)
                            .frame(maxWidth: 60, maxHeight: 60)
                    }
                    .padding(.top, appModel.selectedHat == "nohat" ? 30 : 45)
                    .padding(.bottom, 39)
                    .scaleEffect(1.2)
                    .offset(y:20)
                }
                
                Text(GKLocalPlayer.local.isAuthenticated ? GKLocalPlayer.local.displayName : "Unknown Player")
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: 150)
                    .bold()
                    .italic()
                    .font(.title)
                Text("Beat My Top Score: \(bestScore)")
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
            backgroundColor
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
                    .foregroundColor(.black)
                    .padding(9)
                    .padding(.horizontal, 6)
                    .background(backgroundColor)
                    .cornerRadius(30)
                    .padding(30)
                }
            }
        }
        .sheet(isPresented: $sheetPresented, content: {
                
            if let data = render() {
       
                ShareView(activityItems: [data])
           
            }
            
        })
        .ignoresSafeArea()
    }
}

#Preview {
    PlayersPlaqueView(backgroundColor: .constant(Color.pink))
}
