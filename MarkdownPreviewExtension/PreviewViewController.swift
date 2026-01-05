import Cocoa
import Quartz
import SwiftUI

final class PreviewViewController: NSViewController, QLPreviewingController {
    private let model = MarkdownPreviewModel()
    private lazy var hostingView = NSHostingView(rootView: MarkdownPreview(model: model))

    override func loadView() {
        view = hostingView
    }

    func preparePreviewOfFile(at url: URL, completionHandler handler: @escaping (Error?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let markdownContent = try String(contentsOf: url, encoding: .utf8)
                DispatchQueue.main.async {
                    self?.model.markdownText = markdownContent
                    handler(nil)
                }
            } catch {
                DispatchQueue.main.async {
                    handler(error)
                }
            }
        }
    }
}
