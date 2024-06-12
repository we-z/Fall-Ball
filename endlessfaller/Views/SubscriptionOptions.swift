//
//  SubscriptionOptions.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 6/11/24.
//

import SwiftUI

struct SubscriptionOptions: View {
    @Binding var bundle: CurrencyBundle
    @State var subscriptionDeal = 0
    @State var subscriptionPlans: [BundleSubscription] = [
        BundleSubscription(image: "small-pile", coins: 35, cost: "$4.99", bundleID: "25boins"),
        BundleSubscription(image: "box-pile", coins: 75, cost: "$9.99", bundleID: "55boins"),
        BundleSubscription(image: "bucket-pile", coins: 200, cost: "$19.99", bundleID: "125boins"),
        BundleSubscription(image: "crate-pile", coins: 500, cost: "$49.99", bundleID: "350boins"),
        BundleSubscription(image: "big-pile", coins: 1000, cost: "$99.99", bundleID: "800boins")
    ]
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    var body: some View {
        ZStack{
            RandomGradientView()
                .ignoresSafeArea()
            VStack {
                Capsule()
                    .frame(maxWidth: 45, maxHeight: 9)
                    .padding(.top, 9)
                    .foregroundColor(.black)
                    .opacity(0.3)
                Spacer()
                Image(bundle.image)
                    .resizable()
                    .frame(width: 300, height: 300)
                    .customTextStroke()
                    .padding(.leading)
                    .animatedOffset(speed: 1)
                Spacer()
                Text("Subscribe and Get More")
                    .font(.system(size: 27))
                    .bold()
                    .italic()
                    .customTextStroke(width:2.1)
                    .padding()
                Button{

                } label: {
                    HStack{
                        Spacer()
                        BoinsView()
                        Text(String(subscriptionDeal)+" / week")
                            .bold()
                            .italic()
                            .font(.title)
                            .customTextStroke(width: 1.8)
                            .padding(.vertical)
                        Spacer()
                    }
                    .background(.yellow)
                    .cornerRadius(27)
                    .padding(.horizontal, 30)
                    .padding(.bottom, idiom == .pad || UIDevice.isOldDevice ? 30 : 0)
                }
                .buttonStyle(.roundedAndShadow9)
                Button{

                } label: {
                    HStack{
                        Spacer()
                        BoinsView()
                            .scaleEffect(0.6)
                            .offset(x: 9, y:6)
                        Text(String(bundle.coins)+" one time")
                            .bold()
                            .italic()
                            .font(.system(size: 21))
                            .customTextStroke(width: 1.5)
                            .padding(.top)
                        Spacer()
                    }
                    .offset(x: -6)
                    .padding(.bottom, idiom == .pad || UIDevice.isOldDevice ? 30 : 0)
                }
            }
        }
        .onAppear{
            subscriptionDeal = subscriptionPlans.first(where: {$0.bundleID == bundle.bundleID})!.coins
        }
    }
}

struct BundleSubscription: Hashable {
    let image: String
    let coins: Int // Note: I corrected the type name to 'AnyView' (with a capital 'A')
    let cost: String
    let bundleID: String

    func hash(into hasher: inout Hasher) {
        // Implement a custom hash function that combines the hash values of properties that uniquely identify a character
        hasher.combine(bundleID)
    }

    static func ==(lhs: BundleSubscription, rhs: BundleSubscription) -> Bool {
        // Implement the equality operator to compare characters based on their unique identifier
        return lhs.bundleID == rhs.bundleID
    }
}
