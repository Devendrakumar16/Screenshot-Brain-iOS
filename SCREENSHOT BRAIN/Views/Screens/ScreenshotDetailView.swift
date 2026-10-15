//
//  ScreenshotDetailView.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import SwiftUI
import Photos

import SwiftUI
import Photos

struct ScreenshotDetailView: View {

    let asset: PHAsset

    @Environment(\.dismiss) private var dismiss

    @State private var image: UIImage?

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            if let image {

                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                    .padding()
            } else {

                ProgressView()
                    .tint(.white)
            }

            VStack {

                HStack {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(
                                width: 40,
                                height: 40
                            )
                            .background(
                                .black.opacity(0.6)
                            )
                            .clipShape(Circle())
                    }

                    Spacer()
                }
                .padding()

                Spacer()
            }
        }
        .onAppear {
            loadImage()
        }
    }

    private func loadImage() {

        let options = PHImageRequestOptions()

        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .none

        PHImageManager.default().requestImageDataAndOrientation(
            for: asset,
            options: options
        ) { data, _, _, info in

            guard let data else {
                print("❌ Failed to load screenshot")
                print("Asset:", asset.localIdentifier)
                print("Info:", info ?? [:])
                return
            }

            guard let uiImage = UIImage(data: data) else {
                print("❌ Could not create UIImage")
                return
            }

            DispatchQueue.main.async {
                image = uiImage
            }
        }
    }
}
