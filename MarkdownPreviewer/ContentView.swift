//
//  ContentView.swift
//  MarkdownPreviewer
//
//  Created by Dominik Mazura on 05.01.2026.
//

import AppKit
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Label("Markdown Previewer", systemImage: "doc.text.magnifyingglass")
                .font(.title2.weight(.semibold))

            Text("Quick Look extension is installed with this app. To use it:")
                .font(.body)

            VStack(alignment: .leading, spacing: 8) {
                Label("Keep the app in /Applications.", systemImage: "folder")
                Label("Launch the app once after install.", systemImage: "play.circle")
                Label("In Finder, select a .md file and press Space.", systemImage: "keyboard")
            }
            .font(.body)

            HStack(spacing: 12) {
                Button("Open Extensions Settings") {
                    openExtensionsSettings()
                }
                Button("Open Finder") {
                    NSWorkspace.shared.open(FileManager.default.homeDirectoryForCurrentUser)
                }
            }

            Spacer()
        }
        .padding(24)
        .frame(minWidth: 480, minHeight: 320)
    }

    private func openExtensionsSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.Extensions-Settings.extension?QuickLook") else {
            return
        }
        NSWorkspace.shared.open(url)
    }
}

#Preview {
    ContentView()
}
