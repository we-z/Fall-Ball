//
//  TempView.swift
//  Endless Fall
//
//  Created by Wheezy Salem on 7/14/23.
//

import SwiftUI

struct TempView: View {
    var textView: some View {
        Text("Hello, SwiftUI")
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
    }

    var body: some View {
        VStack {
            textView

            Button("Save to image") {
                let image = textView.snapshot()

                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
    }
}

extension View {
    func snapshot() -> UIImage {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        let renderer = UIGraphicsImageRenderer(size: targetSize)

        return renderer.image { _ in
            view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
        }
    }
}

struct TempView_Previews: PreviewProvider {
    static var previews: some View {
        TempView()
    }
}
