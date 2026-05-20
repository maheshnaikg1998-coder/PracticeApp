// ContentView.swift
// PracticeApp - Practice Project for Speechify Assessment
//
// THIS FILE HAS INTENTIONAL BUGS — your job is to find and fix them!
// Bugs are marked with: // BUG:

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            BuggyListView()
                .tabItem {
                    Label("Books", systemImage: "book")
                }

            BuggyFormView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }

            BuggyNetworkView()
                .tabItem {
                    Label("Feed", systemImage: "antenna.radiowaves.left.and.right")
                }
        }
    }
}
