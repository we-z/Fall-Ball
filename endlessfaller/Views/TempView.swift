//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    @State private var countdown: Int? = nil
        @State private var timer: Timer? = nil

        var body: some View {
            VStack {
                if let countdown = countdown {
                    Text("\(countdown)")
                        .font(.largeTitle)
                        .padding()
                }

                Button(action: {
                    startCountdown()
                }) {
                    Text("Start Countdown")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
        }

        private func startCountdown() {
            // Invalidate the current timer if it exists
            timer?.invalidate()
            timer = nil

            // Start a new countdown
            countdown = 3

            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                if let currentCount = countdown {
                    if currentCount > 0 {
                        countdown = currentCount - 1
                    } else {
                        timer.invalidate()
                        self.timer = nil
                        countdown = nil
                    }
                }
            }
        }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
