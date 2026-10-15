//
//  Home.swift
//  SCREENSHOT BRAIN
//
//  Created by Devendra Kumar on 17/08/26.
//

import SwiftUI
import Photos


struct SelectedScreenshot: Identifiable {
    let id: String
    let asset: PHAsset

    init(asset: PHAsset) {
        self.id = asset.localIdentifier
        self.asset = asset
    }
}

struct Home: View {

    @State private var searchText = ""
    @State private var selectedScreenshot: SelectedScreenshot?
    @State private var selectedCategory: ScreenshotCategories?
    @FocusState private var isKeyboardVisible: Bool

    @ObservedObject var photoManager: PhotoLibraryManager

    var body: some View {
        ZStack {

            // MARK: - Background

            AppTheme.backgroundGradient
                .ignoresSafeArea()

            Circle()
                .fill(AppTheme.primary.opacity(0.25))
                .frame(width: 220)
                .blur(radius: 50)
                .offset(x: -140, y: -300)

            Circle()
                .fill(AppTheme.accent.opacity(0.22))
                .frame(width: 250)
                .blur(radius: 60)
                .offset(x: 150, y: -180)

            Circle()
                .fill(AppTheme.secondary.opacity(0.18))
                .frame(width: 220)
                .blur(radius: 60)
                .offset(x: 130, y: 350)

            // MARK: - Content
            ScrollView{
                VStack {
                    
                    Text(Constant.appName)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Text("Search your screenshot")
                        .font(.title3.bold())
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.top, 30)
                    
                    // MARK: - Search
                    
                    SearchBar
                       // .padding(.top, 20)
                    
                    // MARK: - Recent
                    
                    Text("Recent")
                        .font(.title3.bold())
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.top, 15)
                    
                    // MARK: - Screenshots
                    
                    Screenshots
                    
                    // MARK: Categories
                    
                    Text("Categories")
                        .font(.title3.bold())
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .padding(.top, 25)
                    
                    Categories
                    
                    Spacer()
                }
                .onTapGesture {
                    isKeyboardVisible = false
                }
                .padding()
                
            }
            
        }

        // MARK: - Screenshot Detail

        .fullScreenCover(
            item: $selectedScreenshot
        ) { selected in

            ScreenshotDetailView(
                asset: selected.asset
            )
        }

        // MARK: - Photo Permission

        .task {
            await photoManager.requestAccess()
        }
        .sheet(item: $selectedCategory) { category in
            
            CategoryScreenshotsView(
                category: category,
                photoManager: photoManager
            )
        }

    }
    // MARK: - Search Bar

    private var SearchBar: some View {

        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .font(.title2)
                .frame(width: 24)

            TextField(
                "Search",
                text: $searchText
            )
            .frame(maxWidth: .infinity)
            .focused($isKeyboardVisible)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(.white.opacity(0.3))
        .clipShape(
            RoundedRectangle(cornerRadius: 12)
        )
        .padding(.horizontal, 15)
    }

    // MARK: - Screenshots
    private var Screenshots: some View {

        ScrollView(.horizontal, showsIndicators: false) {

            LazyHStack(spacing: 12) {

                ForEach(
                    photoManager.screenshots,
                    id: \.localIdentifier
                ) { asset in

                    ScreenshotCell(
                        asset: asset,
                        photoManager: photoManager
                    )
                    .onAppear {

                        photoManager.loadMoreIfNeeded(
                            currentItem: asset
                        )
                    }
                }
            }
            .padding(.horizontal, 4)
        }
        .frame(height: 180)
        .background(Color.clear)
    }
    // MARK: - Categories
    private var Categories: some View {

        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ],
            spacing: 12
        ) {

            ForEach(ScreenshotCategories.allCases) { category in

                CategoryCard(
                    category: category,
                    count: photoManager.categoryCount(
                        for: category
                    )
                ).onTapGesture {
                    selectedCategory = category
                }
            }
        }
    }
}
    
