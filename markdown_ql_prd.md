# PRD — Markdown Quick Look Extension (macOS)
Version: 1.0  
Type: Feature/Product Requirements Document  
Target use: Cursor (Plan Mode)

## 1. Overview
We want to build a macOS Quick Look Preview Extension that displays `.md` Markdown files in a clean, modern, styled HTML preview.  
The extension will use SwiftUI + WKWebView + marked.js.  
Dark/light mode follows system appearance automatically.  
No user controls.

## 2. Goals
- Provide clean Markdown Quick Look preview.
- Follow system dark/light mode.
- Fast, simple, lightweight.

## 3. Non-Goals
- No UI controls.
- No preferences.
- No raw mode.
- No editing.
- No advanced highlighting.

## 4. Target Platforms
- macOS 12+
- Xcode project with:
  - macOS App container
  - Quick Look Preview Extension target

## 5. Functional Requirements
### File Types
- .md, .markdown  
- UTIs: net.daringfireball.markdown, public.plain-text

### Rendering
- Load file content
- Convert markdown → HTML via marked.js
- Inject HTML template in WebView

### Appearance
- Automatic light/dark mode (CSS media query)
- Styled code blocks
- Responsive images
- macOS typography

### WebView
- WKWebView inside SwiftUI NSViewRepresentable

## 6. Technical Requirements
### File Loading
- PreparePreviewOfFile loads utf-8 text

### SwiftUI Structure
- NSHostingView wrapping MarkdownPreview

### HTML Template
- Includes meta viewport
- Includes marked.js via CDN
- Inline CSS
- JS code to render markdown

### CSS
- Base: macOS-style typography
- Dark mode via prefers-color-scheme: dark
- Code block background
- Images max-width 100%

## 7. Directory Structure
/MarkdownPreviewer  
  /MarkdownPreviewExtension  
    - PreviewViewController.swift  
    - MarkdownPreview.swift  
    - MarkdownWebView.swift  
    - MarkdownHTML.swift  
    - Info.plist  

## 8. Key Files
### PreviewViewController.swift
- Loads file, passes text to SwiftUI view

### MarkdownPreview.swift
- SwiftUI wrapper around WebView

### MarkdownWebView.swift
- Loads HTML template into WKWebView

### MarkdownHTML.swift
- Contains HTML + CSS + JS template

## 9. Acceptance Criteria
- Renders all common markdown
- Dark/light mode auto
- Works in Finder, Quick Look, Spotlight
- No JS errors
- Offline-friendly (except CDN)

## 10. Future Extensions
- Raw mode
- Syntax highlighting
- Preferences
- Themes
- Mermaid diagrams

## 11. Cursor Instructions
Cursor should:
1. Generate code for all Swift files.
2. Implement WebView HTML injection.
3. Add UTI config to Info.plist.
4. Ensure dark/light mode via CSS.
5. No UI controls.
6. Use SwiftUI + WKWebView.

