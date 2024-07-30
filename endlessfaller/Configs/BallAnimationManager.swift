//
//  BallAnimationManager.swift
//  Fall Ball
//
//  Created by Wheezy Salem on 2/15/24.
//

import Foundation
import QuartzCore
import UIKit
import SwiftUI

class BallAnimationManager: ObservableObject {
    @Published var ballYPosition: CGFloat = 90
    @Published var startingYPosition: CGFloat = 0
    @Published var endingYPosition: CGFloat = 90
    @Published var newBallSpeed: CGFloat = 0
    @Published var startTime: CFTimeInterval = 0.0
    @Published var displayLink: CADisplayLink?
    @Published var pushUp: Bool = false
    @Published var ballSpeed: Double = 0.0
    @Published var targetDuration: CFTimeInterval = 0
    @Published var screenCeiling: CGFloat = 0
    
    @ObservedObject var userPersistedData = UserPersistedData()
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    static let sharedBallManager = BallAnimationManager()
    
    init() {
        if self.idiom == .pad {
            self.screenCeiling = 60
        } else {
            self.screenCeiling = 90
         }
    }
    
    func startTimer(speed: Double) {
        // Invalidate the existing display link
        self.displayLink?.invalidate()
        
        ballSpeed = speed
        
        // Create a new display link
        displayLink = CADisplayLink(target: self, selector: #selector(update(_:)))
        displayLink?.add(to: .current, forMode: .common)
        //displayLink?.preferredFrameRateRange = CAFrameRateRange(minimum: 15.0 , maximum: 60.0, preferred: 60.0)
        
        // Set the start time
        startTime = CACurrentMediaTime()
    }
    
    func pushBallUp(newBallSpeed: CGFloat) {
        if newBallSpeed < 0.3 {
            ballSpeed = newBallSpeed
        } else {
            ballSpeed = 0.3
        }
        self.newBallSpeed = newBallSpeed
        startingYPosition = ballYPosition
        if userPersistedData.strategyModeEnabled {
            endingYPosition = startingYPosition - UIScreen.main.bounds.height * ((newBallSpeed * 0.06) + 0.1)
        } else {
            endingYPosition = startingYPosition - UIScreen.main.bounds.height * ((newBallSpeed * 0.06) + 0.1)
        }
        startTime = CACurrentMediaTime()
        pushUp = true
    }
    
    @objc func update(_ displayLink: CADisplayLink) {
        let currentTime = CACurrentMediaTime()
        let elapsedTime = currentTime - startTime
        
        // Calculate the target duration (2 seconds)
        targetDuration = ballSpeed
        
        // Calculate the ball position based on elapsed time and speed
        if elapsedTime < targetDuration {
            if pushUp {
                //calculate the inverse position from startingYPosition to endingYPosition. use half of screen as the number to get the percentage of.
                ballYPosition = startingYPosition - ((CGFloat(elapsedTime / targetDuration) * UIScreen.main.bounds.height) / 3)
                if ballYPosition <= endingYPosition + 90 || (self.ballYPosition < self.screenCeiling && self.userPersistedData.strategyModeEnabled == false){
//                    print("ball should stop pushing")
                    if self.ballYPosition < self.screenCeiling {
                        self.endingYPosition = screenCeiling
                        self.ballYPosition = screenCeiling
                    }
                    self.pushUp = false
                    startTimer(speed: newBallSpeed)
                }
            } else {
                ballYPosition = endingYPosition + (CGFloat(elapsedTime / targetDuration) * (UIScreen.main.bounds.height))
            }
        }

        if deviceHeight - 60 < self.ballYPosition || (self.ballYPosition < self.screenCeiling && self.userPersistedData.strategyModeEnabled) {
            print("Ball died at: ")
            print(self.ballYPosition)
            AppModel.sharedAppModel.wastedOperations()
        }
    }
    
}
