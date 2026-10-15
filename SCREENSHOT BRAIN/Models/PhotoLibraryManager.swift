//
//  PAAsset.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import Photos
import UIKit
import SwiftUI
internal import Combine
import SwiftData

@MainActor
final class PhotoLibraryManager: NSObject, ObservableObject {

    @Published var screenshots: [PHAsset] = []
    @Published private(set) var categoryCounts: [ScreenshotCategories: Int] = [:]

    private let imageManager = PHCachingImageManager()
    private let screenshotProcessor = ScreenshotProcessor()
    private let screenshotRecordStore: ScreenshotRecordStore
    private var allAssets: PHFetchResult<PHAsset>?
    private var categorizationTask: Task<Void, Never>?
    private let thumbnailCache = NSCache<NSString, UIImage>()
    private let aiCategorizationVersionKey = "aiCategorizationVersion"
    private let currentAICategorizationVersion = 2
    private var metadataByAssetIdentifier: [String: ScreenshotMetadata] = [:]

    private let pageSize = 30
    private var currentIndex = 0

    init(modelContainer: ModelContainer) {
        screenshotRecordStore = ScreenshotRecordStore(
            modelContainer: modelContainer
        )

        super.init()
        PHPhotoLibrary.shared().register(self)
    }

    deinit {
        PHPhotoLibrary.shared().unregisterChangeObserver(self)
    }

    func requestAccess() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)

        guard status == .authorized || status == .limited else {
            return
        }

        await loadPersistedMetadata()
        if allAssets == nil {
            fetchScreenshots()
        }
        startBackgroundCategorization()
    }

    private func fetchScreenshots() {

        let options = PHFetchOptions()

        options.sortDescriptors = [
            NSSortDescriptor(
                key: "creationDate",
                ascending: false
            )
        ]
        options.predicate = NSPredicate(
            format: "(mediaSubtype & %d) != 0",
            PHAssetMediaSubtype.photoScreenshot.rawValue
        )

        let result = PHAsset.fetchAssets(
            with: .image,
            options: options
        )

        allAssets = result
        screenshots = []
        currentIndex = 0

        loadNextPage()
    }

    func screenshots(
        for category: ScreenshotCategories
    ) -> [PHAsset] {
        guard let allAssets else {
            return []
        }

        let matchingAssetIdentifiers = Set(
            metadataByAssetIdentifier.values.compactMap { metadata in
                metadata.category == category
                    ? metadata.assetIdentifier
                    : nil
            }
        )

        guard !matchingAssetIdentifiers.isEmpty else {
            return []
        }

        var categorizedScreenshots: [PHAsset] = []

        allAssets.enumerateObjects { asset, _, _ in
            if matchingAssetIdentifiers.contains(asset.localIdentifier) {
                categorizedScreenshots.append(asset)
            }
        }

        return categorizedScreenshots
    }

    private func loadPersistedMetadata() async {
        do {
            metadataByAssetIdentifier = try await screenshotRecordStore
                .loadMetadataByAssetIdentifier()
            rebuildCategoryCounts()
        } catch {
            print("❌ Failed to load saved screenshot records")
            print("Error:", error.localizedDescription)
        }
    }

    private func startBackgroundCategorization() {
        guard categorizationTask == nil else {
            return
        }

        categorizationTask = Task(
            priority: .utility
        ) { [weak self] in
            guard let self else {
                return
            }

            await self.categorizeAllScreenshots()

            await MainActor.run {
                self.categorizationTask = nil
            }
        }
    }

    private func categorizeAllScreenshots() async {
        guard let allAssets else {
            return
        }

        let storedAICategorizationVersion = UserDefaults.standard.integer(
            forKey: aiCategorizationVersionKey
        )
        let shouldRefreshExistingCategories =
            storedAICategorizationVersion < currentAICategorizationVersion
        var pendingMetadataUpdates: [String: ScreenshotMetadata] = [:]

        for index in 0..<allAssets.count {
            if Task.isCancelled {
                return
            }

            let asset = allAssets.object(at: index)

            guard
                shouldRefreshExistingCategories ||
                metadataByAssetIdentifier[asset.localIdentifier] == nil
            else {
                continue
            }

            guard let metadata = await screenshotProcessor.process(asset: asset) else {
                continue
            }

            do {
                try await screenshotRecordStore.save(
                    metadata: metadata
                )
                pendingMetadataUpdates[asset.localIdentifier] = metadata

                if pendingMetadataUpdates.count >= 10 {
                    applyMetadataUpdates(
                        pendingMetadataUpdates
                    )
                    pendingMetadataUpdates.removeAll(
                        keepingCapacity: true
                    )
                }
            } catch {
                print("❌ Failed to save screenshot record")
                print("Asset:", asset.localIdentifier)
                print("Error:", error.localizedDescription)
            }
        }

        if !pendingMetadataUpdates.isEmpty {
            applyMetadataUpdates(
                pendingMetadataUpdates
            )
        }

        if shouldRefreshExistingCategories {
            UserDefaults.standard.set(
                currentAICategorizationVersion,
                forKey: aiCategorizationVersionKey
            )
        }
    }

    func categoryCount(
        for category: ScreenshotCategories
    ) -> Int {
        categoryCounts[category, default: 0]
    }

    func image(
        for asset: PHAsset,
        size: CGSize,
        completion: @escaping (UIImage?) -> Void
    ) {
        let cacheKey = thumbnailCacheKey(
            for: asset,
            size: size
        )

        if let cachedImage = thumbnailCache.object(
            forKey: cacheKey
        ) {
            completion(cachedImage)
            return
        }

        let options = PHImageRequestOptions()

        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFit,
            options: options
        ) { image, _ in

            DispatchQueue.main.async {
                if let image {
                    self.thumbnailCache.setObject(
                        image,
                        forKey: cacheKey
                    )
                }
                completion(image)
            }
        }
    }
    
    func fullResolutionImage(
        for asset: PHAsset
    ) async -> UIImage? {

        await withCheckedContinuation { continuation in

            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            options.deliveryMode = .highQualityFormat
            options.resizeMode = .none

            PHImageManager.default().requestImageDataAndOrientation(
                for: asset,
                options: options
            ) { data, _, _, info in

                guard let data else {
                    print("❌ Could not get original image")
                    print("Info:", info ?? [:])
                    continuation.resume(returning: nil)
                    return
                }

                guard let image = UIImage(data: data) else {
                    print("❌ Could not create UIImage")
                    continuation.resume(returning: nil)
                    return
                }

                continuation.resume(returning: image)
            }
        }
    }
    
    private func loadNextPage() {

        guard let allAssets else {
            return
        }

        let start = currentIndex

        let end = min(
            start + pageSize,
            allAssets.count
        )

        guard start < end else {
            return
        }

        var newAssets: [PHAsset] = []

        for index in start..<end {
            let asset = allAssets.object(at: index)
            newAssets.append(asset)
        }

        screenshots.append(contentsOf: newAssets)
        startCachingThumbnails(
            for: newAssets
        )

        currentIndex = end
    }
    func loadMoreIfNeeded(
        currentItem: PHAsset
    ) {

        guard let index =
                screenshots.firstIndex(
                    where: {
                        $0.localIdentifier ==
                        currentItem.localIdentifier
                    }
        ) else {
            return
        }

        let thresholdIndex =
            screenshots.count - 5

        if index >= thresholdIndex {

            loadNextPage()
        }
    }

    private func thumbnailCacheKey(
        for asset: PHAsset,
        size: CGSize
    ) -> NSString {
        "\(asset.localIdentifier)-\(Int(size.width))x\(Int(size.height))" as NSString
    }

    private func startCachingThumbnails(
        for assets: [PHAsset]
    ) {
        guard !assets.isEmpty else {
            return
        }

        let targetSize = CGSize(
            width: 300,
            height: 300
        )

        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true

        imageManager.startCachingImages(
            for: assets,
            targetSize: targetSize,
            contentMode: .aspectFit,
            options: options
        )
    }

    private func applyMetadataUpdates(
        _ updates: [String: ScreenshotMetadata]
    ) {
        metadataByAssetIdentifier.merge(
            updates
        ) { _, new in
            new
        }

        rebuildCategoryCounts()
    }

    private func rebuildCategoryCounts() {
        var updatedCounts: [ScreenshotCategories: Int] = [:]

        for category in ScreenshotCategories.allCases {
            updatedCounts[category] = 0
        }

        for metadata in metadataByAssetIdentifier.values {
            updatedCounts[metadata.category, default: 0] += 1
        }

        categoryCounts = updatedCounts
    }

    private func applyUpdatedFetchResult(
        _ updatedFetchResult: PHFetchResult<PHAsset>
    ) {
        allAssets = updatedFetchResult

        let visibleCount = min(
            currentIndex,
            updatedFetchResult.count
        )

        var updatedVisibleScreenshots: [PHAsset] = []

        if visibleCount > 0 {
            for index in 0..<visibleCount {
                updatedVisibleScreenshots.append(
                    updatedFetchResult.object(at: index)
                )
            }
        }

        screenshots = updatedVisibleScreenshots
        currentIndex = visibleCount

        startCachingThumbnails(
            for: updatedVisibleScreenshots
        )
        startBackgroundCategorization()
    }
}

extension PhotoLibraryManager: PHPhotoLibraryChangeObserver {
    nonisolated func photoLibraryDidChange(
        _ changeInstance: PHChange
    ) {
        Task { @MainActor [weak self] in
            guard
                let self,
                let allAssets,
                let changeDetails = changeInstance.changeDetails(
                    for: allAssets
                )
            else {
                return
            }

            self.applyUpdatedFetchResult(
                changeDetails.fetchResultAfterChanges
            )
        }
    }
}
