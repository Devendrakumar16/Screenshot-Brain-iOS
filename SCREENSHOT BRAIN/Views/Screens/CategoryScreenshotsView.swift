//
//  CategoryScreenshotsView.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//


import SwiftUI
import Photos

struct CategoryScreenshotsView: View {
    let category: ScreenshotCategories
    @ObservedObject var photoManager: PhotoLibraryManager

    @State private var selectedScreenshot: SelectedScreenshot?

    @Environment(\.dismiss) private var dismiss

    private let columns = [
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10),
        GridItem(.flexible(), spacing: 10)
    ]

    private var screenshots: [PHAsset] {
        photoManager.screenshots(for: category)
    }

    var body: some View {

        NavigationStack {

            ScrollView {
                if !screenshots.isEmpty {
                    LazyVGrid(
                        columns: columns,
                        spacing: 10
                    ) {
                        
                        ForEach(
                            screenshots,
                            id: \.localIdentifier
                            
                        ) { asset in
                            
                            ScreenshotCell(
                                asset: asset,
                                photoManager: photoManager
                            )
                            .onTapGesture {
                                selectedScreenshot = SelectedScreenshot(
                                    asset: asset
                                )
                            }
                        }
                    }
                    .padding()
                }else{
                    VStack{
                        Spacer()
                        Text("No data in this category")
                            .font(.title.bold())
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        Spacer()
                    }
                }
            }
            .navigationTitle(category.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {

                ToolbarItem(
                    placement: .topBarTrailing
                ) {

                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
        .fullScreenCover(
            item: $selectedScreenshot
        ) { selected in
            ScreenshotDetailView(
                asset: selected.asset
            )
        }
    }
}
