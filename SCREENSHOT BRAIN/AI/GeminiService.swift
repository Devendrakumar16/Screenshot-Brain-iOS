//
//  GeminiService.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 18/08/26.
//

import Foundation

final class GeminiService {

    // This service is now a no-op. Categorization is decided by OCR pipeline.
    // We keep the same API to avoid touching call sites.
    func categorize(text: String) async throws -> String {
        // If you want a tiny heuristic fallback, add it here. For now, always defer to OCR.
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return "Other"
        }
        return "Other"
    }
}

// MARK: - Errors (kept for compatibility if referenced elsewhere)

enum GeminiError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case emptyResponse
    case invalidCategory(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid Gemini URL."
        case .invalidResponse:
            return "Invalid response from Gemini."
        case .serverError(let statusCode):
            return "Gemini server error: \(statusCode)"
        case .emptyResponse:
            return "Gemini returned an empty response."
        case .invalidCategory(let category):
            return "Gemini returned invalid category: \(category)"
        }
    }
}
