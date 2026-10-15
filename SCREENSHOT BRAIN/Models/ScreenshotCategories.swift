//
//  ScreenshotCategories.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import SwiftUI
enum ScreenshotCategories: String, CaseIterable, Identifiable, Codable {

    case coding = "Coding"
    case shopping = "Shopping"
    case travel = "Travel"
    case food = "Food"
    case work = "Work"
    case social = "Social"
    case finance = "Finance"
    case learning = "Learning"
    case documents = "Documents"
    case other = "Other"

    var id: String {
        rawValue
    }

    var keywords: [String] {

        switch self {

        case .coding:
            return [
                "swift",
                "swiftui",
                "xcode",
                "ios",
                "developer",
                "github",
                "code",
                "programming",
                "api",
                "json",
                "uikit"
            ]

        case .shopping:
            return [
                "buy",
                "cart",
                "price",
                "amazon",
                "flipkart",
                "nike",
                "product",
                "order",
                "delivery"
            ]

        case .travel:
            return [
                "flight",
                "airport",
                "boarding",
                "hotel",
                "booking",
                "trip",
                "train",
                "indigo",
                "air india"
            ]

        case .food:
            return [
                "restaurant",
                "menu",
                "food",
                "biryani",
                "pizza",
                "burger",
                "cafe",
                "delivery"
            ]

        case .work:
            return [
                "meeting",
                "office",
                "project",
                "task",
                "deadline",
                "employee",
                "manager"
            ]

        case .social:
            return [
                "instagram",
                "facebook",
                "whatsapp",
                "twitter",
                "message",
                "followers",
                "likes",
                "comment"
            ]

        case .finance:
            return [
                "payment",
                "transaction",
                "bank",
                "upi",
                "account",
                "balance",
                "₹",
                "rupee",
                "credit",
                "debit"
            ]

        case .learning:
            return [
                "learn",
                "course",
                "tutorial",
                "lesson",
                "book",
                "chapter",
                "study",
                "exam"
            ]

        case .documents:
            return [
                "document",
                "invoice",
                "receipt",
                "certificate",
                "application",
                "form",
                "terms",
                "agreement"
            ]

        case .other:
            return []
        }
    }

    var icon: String {
          switch self {

          case .coding:
              return "chevron.left.forwardslash.chevron.right"
          case .shopping:
              return "bag.fill"
          case .travel:
              return "airplane"
          case .food:
              return "fork.knife"
          case .work:
              return "briefcase.fill"
          case .finance:
              return "indianrupeesign.circle.fill"
          case .documents:
              return "doc.fill"
          case .social:
              return "message.fill"
          case .learning:
              return "book.fill"
          case .other:
              return "key.fill"
          }
      }

      var color: Color {
          switch self {
 
          case .coding:
              return .purple
          case .shopping:
              return .pink
          case .travel:
              return .blue
          case .food:
              return .orange
          case .work:
              return .teal
          case .finance:
              return .green
          case .documents:
              return .indigo
          case .social:
              return .red
          case .learning:
              return .pink
          case .other:
              return .pink
          }
      }
}
