// BuggyListView.swift
// Contains: 1 crash bug, 1 UI bug

import SwiftUI

struct Book: Identifiable {
    let id: Int  // BUG 1: Should be UUID, not Int — List will crash without unique IDs generated properly
    let title: String
    let author: String
    let pages: Int
}

class BookViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var isLoading = false

    func loadBooks() {
        isLoading = true
        // Simulating data load
        // BUG 2: All books have same id = 0, causing duplicate ID crash in List
        books = [
            Book(id: 0, title: "Swift Programming", author: "Apple", pages: 300),
            Book(id: 0, title: "SwiftUI Essentials", author: "Paul Hudson", pages: 250),
            Book(id: 0, title: "Combine Framework", author: "Joseph Heck", pages: 200)
        ]
        isLoading = false
    }
}

struct BuggyListView: View {
    @StateObject private var viewModel = BookViewModel()

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else {
                    List(viewModel.books) { book in
                        BookRowView(book: book)
                    }
                }
            }
            .navigationTitle("My Books")
            // BUG 3: loadBooks() is never called — list will always be empty
        }
    }
}

struct BookRowView: View {
    let book: Book

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(book.title)
                .font(.headline)
            Text(book.author)
                .font(.subheadline)
                .foregroundColor(.gray)
            // BUG 4 (UI): Pages label is missing — it should show "300 pages" below author
        }
        .padding(.vertical, 4)
    }
}

// ─────────────────────────────────────────
// FIXES (read after attempting yourself!)
// ─────────────────────────────────────────
//
// FIX 1 & 2: Change id type to UUID and assign unique ids:
//   let id: UUID
//   Book(id: UUID(), title: ...)
//
// FIX 3: Add .onAppear { viewModel.loadBooks() } to Group
//
// FIX 4: Add below the author Text:
//   Text("\(book.pages) pages")
//       .font(.caption)
//       .foregroundColor(.secondary)
