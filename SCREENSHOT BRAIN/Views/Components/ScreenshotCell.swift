//
//  ScreenshotCell.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import SwiftUI
import Photos

struct ScreenshotCell: View {

    let asset: PHAsset
    let photoManager: PhotoLibraryManager

    @State private var image: UIImage?

    var body: some View {

        Group {
            if let image {

                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()

            } else {

                RoundedRectangle(cornerRadius: 14)
                    .fill(.white.opacity(0.5))
                    .overlay {
                        ProgressView()
                    }
            }
        }
        .frame(
            maxWidth: .infinity,
            minHeight: 150,
            maxHeight: 150
        )
        .clipShape(
            RoundedRectangle(cornerRadius: 14)
        )
        .task {

            photoManager.image(
                for: asset,
                size: CGSize(
                    width: 300,
                    height: 300
                )
            ) { image in

                self.image = image
            }
        }
        .onLongPressGesture {

            guard let image else {
                print("❌ Image not loaded")
                return
            }

            Task {

                let processor = ScreenshotProcessor()

                _ = await processor.process(
                    asset: asset
                )
            }
        }
    }
    
}
