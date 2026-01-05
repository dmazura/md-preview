import SwiftUI

struct MarkdownPreview: View {
    @ObservedObject var model: MarkdownPreviewModel

    var body: some View {
        MarkdownWebView(htmlContent: MarkdownHTML.generate(markdown: model.markdownText))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
