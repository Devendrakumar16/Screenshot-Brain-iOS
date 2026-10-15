//
//  OCRService.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import Vision
import UIKit

final class OCRService {

    func recognizeText(
        from image: UIImage
    ) async -> String {

        guard let cgImage = image.cgImage else {
            return ""
        }

        return await withCheckedContinuation { continuation in

            let request = VNRecognizeTextRequest { request, error in

                guard error == nil else {
                    continuation.resume(returning: "")
                    return
                }

                let observations =
                    request.results as? [VNRecognizedTextObservation] ?? []

                let text = observations
                    .compactMap {
                        $0.topCandidates(1).first?.string
                    }
                    .joined(separator: " ")

                continuation.resume(returning: text)
            }

            request.recognitionLevel = .accurate
            request.usesLanguageCorrection = true

            let handler = VNImageRequestHandler(
                cgImage: cgImage,
                options: [:]
            )

            do {
                try handler.perform([request])
            } catch {
                continuation.resume(returning: "")
            }
        }
    }
}