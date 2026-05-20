// BuggyNetworkView.swift
// Contains: 2 networking bugs

import SwiftUI

struct Post: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
}

class FeedViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?

    func fetchPosts() async {
        // BUG 1: URL is wrong — "jsonplaceholder" is misspelled as "jsonplaceholer"
        guard let url = URL(string: "https://jsonplaceholer.typicode.com/posts") else {
            errorMessage = "Invalid URL"
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoded = try JSONDecoder().decode([Post].self, from: data)

            // BUG 2: UI must be updated on main thread — missing MainActor dispatch
            posts = decoded
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct BuggyNetworkView: View {
    @StateObject private var viewModel = FeedViewModel()

    var body: some View {
        NavigationView {
            Group {
                if let error = viewModel.errorMessage {
                    VStack {
                        Image(systemName: "wifi.slash")
                            .font(.largeTitle)
                        Text(error)
                            .multilineTextAlignment(.center)
                            .padding()
                        Button("Retry") {
                            Task { await viewModel.fetchPosts() }
                        }
                    }
                } else if viewModel.posts.isEmpty {
                    ProgressView("Loading feed...")
                } else {
                    List(viewModel.posts) { post in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(post.title)
                                .font(.headline)
                            Text(post.body)
                                .font(.caption)
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .navigationTitle("Feed")
            .task {
                await viewModel.fetchPosts()
            }
        }
    }
}

// ─────────────────────────────────────────
// FIXES
// ─────────────────────────────────────────
//
// FIX 1: Fix the URL typo:
//   "https://jsonplaceholder.typicode.com/posts"
//
// FIX 2: Wrap UI update in MainActor:
//   await MainActor.run {
//       posts = decoded
//   }
//   OR mark fetchPosts() with @MainActor
