# Markdown Quick Look Extension for macOS

A modern, lightweight Quick Look extension that renders Markdown files (`.md`, `.markdown`) with beautiful styling and automatic dark/light mode support.

## Features

- ✨ Clean, GitHub-style Markdown rendering
- 🌓 Automatic dark/light mode based on system appearance
- 🚀 Fast and lightweight
- 📱 Responsive design
- 📦 Offline Markdown parsing (bundled `marked.min.js`)
- 🔗 External links open in default browser
- 📝 Supports all common Markdown syntax (GFM)

## Requirements

- macOS 12.0 or later
- Xcode 13.0 or later

## Project Structure

```
.
├── MarkdownPreviewer.xcodeproj
├── MarkdownPreviewer/               # Minimal host app
├── MarkdownPreviewExtension/        # Quick Look extension
│   ├── MarkdownPreviewModel.swift
│   ├── PreviewViewController.swift
│   ├── MarkdownPreview.swift
│   ├── MarkdownWebView.swift
│   ├── MarkdownHTML.swift
│   ├── marked.min.js
│   ├── MarkdownPreviewExtension.entitlements
│   └── Info.plist
├── README.md
├── markdown_ql_prd.md
└── sample.md
```

## Setup Instructions

### 1. Open the Project

Open `MarkdownPreviewer.xcodeproj` in Xcode.

### 2. Configure UTI Support

The `Info.plist` is already configured to handle:
- `net.daringfireball.markdown` (standard Markdown UTI)
- `public.plain-text` (for `.md` files)

### 3. Build and Run

1. Select the **MarkdownPreviewExtension** scheme
2. Choose **My Mac** as the run destination
3. Build and run (⌘R)
4. When prompted, select **Finder** as the host application
5. Navigate to a folder with `.md` files
6. Press **Space** on a Markdown file to preview

### 4. Install Extension System-Wide

After successful testing:

1. Archive the app (**Product > Archive**)
2. Export the app
3. Move `MarkdownPreviewer.app` to `/Applications/`
4. Launch the app at least once
5. Restart Finder or log out/in

### 5. Create a Drag-and-Drop Installer (.dmg)

Build and package the app into a DMG that users can drag into `/Applications`:

```bash
./scripts/build_dmg.sh --build
```

The DMG is created at `dist/MarkdownPreview.dmg`.

### Branding Assets

Generate the logo and DMG background:

```bash
python3 scripts/generate_assets.py
./scripts/generate_app_icon.sh
```

This creates:
- `assets/icon-1024.png`
- `assets/dmg-background.png`

## Testing

Test with various Markdown files:

```markdown
# Heading 1
## Heading 2

**Bold text** and *italic text*

- List item 1
- List item 2

`inline code`

\`\`\`python
def hello():
    print("Hello, World!")
\`\`\`

[Link](https://example.com)

![Image](https://via.placeholder.com/150)
```

## Technical Details

### Architecture

- **PreviewViewController**: Loads Markdown file content and sets up the preview
- **MarkdownPreview**: SwiftUI view that wraps the web view
- **MarkdownWebView**: NSViewRepresentable wrapper for WKWebView
- **MarkdownHTML**: Generates HTML template with embedded CSS and JavaScript

### Rendering Pipeline

1. Quick Look calls `preparePreviewOfFile(at:completionHandler:)`
2. File content is loaded as UTF-8 string
3. Markdown text is passed to SwiftUI view
4. HTML template is generated with embedded Markdown content
5. WKWebView renders the HTML using the bundled `marked.min.js`

### Dark Mode

Dark mode is handled purely via CSS using `@media (prefers-color-scheme: dark)`. The extension automatically follows the system appearance without any code intervention.

### External Dependencies

- **marked.js**: Bundled as `MarkdownPreviewExtension/marked.min.js` and loaded locally

### Entitlements

The extension ships with `MarkdownPreviewExtension.entitlements` and enables:
- App Sandbox
- User-selected file read access
- Network client (required for WebKit process behavior on some systems)

### Deployment Target

Keep `MACOSX_DEPLOYMENT_TARGET` and `LSMinimumSystemVersion` aligned. The default is **macOS 12.0**.

## Customization

### Styling

Edit the CSS in `MarkdownHTML.swift` to customize:
- Colors and typography
- Code block styling
- Dark mode appearance
- Spacing and layout

### Supported File Types

Add more UTIs in `Info.plist` under `QLSupportedContentTypes`:

```xml
<key>QLSupportedContentTypes</key>
<array>
    <string>net.daringfireball.markdown</string>
    <string>public.plain-text</string>
    <string>your.custom.uti</string>
</array>
```

## Troubleshooting

### Extension Not Appearing

1. Ensure the app is in `/Applications/`
2. Launch the app at least once
3. Check System Preferences > Extensions > Quick Look
4. Restart Finder: `killall Finder`
5. Clear Quick Look cache: `qlmanage -r cache`

### Preview Not Updating

Reset Quick Look:
```bash
qlmanage -r
qlmanage -r cache
killall Finder
```

### Checking Logs

View extension logs in Console.app:
```
com.yourname.MarkdownPreviewer
```

## Future Enhancements

Potential additions (not currently implemented):
- Syntax highlighting for code blocks
- Mermaid diagram support
- Raw Markdown view toggle
- Custom themes
- User preferences

## License

Feel free to use and modify as needed.

## Acknowledgments

- **marked.js**: Fast Markdown parser (https://marked.js.org/)
- GitHub-inspired styling
- Apple's Quick Look framework
