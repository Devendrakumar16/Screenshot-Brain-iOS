//
//  SCREENSHOT_BRAINApp.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import SwiftUI
import SwiftData

@main
struct SCREENSHOT_BRAINApp: App {
    private let sharedModelContainer: ModelContainer

    @StateObject private var photoManager: PhotoLibraryManager

    init() {
        do {
            let modelContainer = try ModelContainer(
                for: ScreenshotRecord.self
            )

            sharedModelContainer = modelContainer
            _photoManager = StateObject(
                wrappedValue: PhotoLibraryManager(
                    modelContainer: modelContainer
                )
            )
        } catch {
            fatalError(
                "Failed to create SwiftData container: \(error.localizedDescription)"
            )
        }
    }

    var body: some Scene {
        WindowGroup {
            Home(
                photoManager: photoManager
            )
        }
        .modelContainer(sharedModelContainer)
    }
}
