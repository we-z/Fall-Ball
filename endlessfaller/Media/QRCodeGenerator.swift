//
//  QRCodeGenerator.swift
//  Fall Ball
//
//  Created by Sam on 4/14/24.
//

import Foundation
import CoreImage
import CoreImage.CIFilterBuiltins
import UIKit


struct QRCodeGenerator {
    /// Generates a QRCode image from a string, the `correctionLevel` is
    /// a string and a bit strange as explained by the [docs](https://developer.apple.com/documentation/coreimage/cifilter/3228262-qrcodegenerator)
    ///
    ///  * "L" is 7 precent correction
    ///  * "M" is 15 precent correction
    ///  * "Q" is 25 precent correction
    ///  * "H" is 30 precent correction
    ///
    ///  Note that higher correction levels don't make the QRCode more
    ///  legible, especially at low resolutions
    func new(_ data: String, correctionLevel: String = "M") -> UIImage? {
        let generator = CIFilter.qrCodeGenerator()
        generator.message = Data(data.utf8)
        
        guard let outputImage = generator.outputImage else {
            debugPrint("Failed to generate QRCode for:\n\nData: \(data)\nCorrection Level: \(correctionLevel)")
            return nil
        }
        
        return UIImage(ciImage: outputImage)
    }
}
