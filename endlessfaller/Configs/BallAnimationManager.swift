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
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    static let sharedBallManager = BallAnimationManager()
    
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
        ballSpeed = 0.3
        self.newBallSpeed = newBallSpeed
        startingYPosition = ballYPosition
        endingYPosition = startingYPosition - UIScreen.main.bounds.height / 3
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
                ballYPosition = startingYPosition - ((CGFloat(elapsedTime / targetDuration) * UIScreen.main.bounds.height) / 3) //CGFloat(elapsedTime / targetDuration) * (UIScreen.main.bounds.height / 2)
                if ballYPosition <= endingYPosition + 90 {
                    //print("ball pushed back all the way up")
                    startTime = CACurrentMediaTime()
                    startTimer(speed: newBallSpeed)
                    self.pushUp = false
                }
            } else {
                ballYPosition = endingYPosition + (CGFloat(elapsedTime / targetDuration) * (UIScreen.main.bounds.height))
            }
        } else {
            displayLink.invalidate()
        }
        
        if self.idiom == .pad {
             self.screenCeiling = 60
         } else {
             if UIDevice.current.hasDynamicIsland {
                 self.screenCeiling = 90
             } else {
                 self.screenCeiling = 80
             }
         }
        
        if deviceHeight - 39 < self.ballYPosition || self.ballYPosition < self.screenCeiling {
            print("Ball died at: ")
            print(self.ballYPosition)
            AppModel.sharedAppModel.wastedOperations()
        }
    }
    
}
