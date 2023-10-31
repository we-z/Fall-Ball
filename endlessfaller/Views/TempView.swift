//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI
import CoreMotion


struct TempView: View {
//    var body: some View {
//
        
//        
//
//    }
    let motionManager = CMMotionManager()
    let queue = OperationQueue()
    @State private var ballRoll = Double.zero

    var body: some View {

        Circle()
            .overlay{
                VStack(spacing: 0){
                    Color.blue
                    Color.red
                }
            }
            .mask{
                Circle()
            }
            .frame(width: 100)
            .rotationEffect(.degrees(ballRoll * 69))
            .onAppear {
                print("ON APPEAR")
                self.motionManager.startDeviceMotionUpdates(to: self.queue) { (data: CMDeviceMotion?, error: Error?) in
                    guard let data = data else {
                        print("Error: \(error!)")
                        return
                    }
                    let attitude: CMAttitude = data.attitude

                    self.ballRoll = attitude.roll
                }
            }//.onappear
    }//view
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
