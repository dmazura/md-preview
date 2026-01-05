import Foundation

struct MarkdownHTML {
    static func generate(markdown: String) -> String {
        return """
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Markdown Preview</title>
            <script src="marked.min.js"></script>
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }
                
                :root {
                    color-scheme: light dark;
                    --bg: #ffffff;
                    --text: #1f2328;
                    --muted: #4b5563;
                    --border: #d0d7de;
                    --link: #0a5bd3;
                    --code-bg: #f6f8fa;
                    --code-text: #111827;
                    --table-alt: #f3f4f6;
                }
                
                @media (prefers-color-scheme: dark) {
                    :root {
                        --bg: #0f1115;
                        --text: #e6e6e6;
                        --muted: #c5ccd6;
                        --border: #3a3f46;
                        --link: #8cbcff;
                        --code-bg: #1b1f24;
                        --code-text: #f3f4f6;
                        --table-alt: #161b22;
                    }
                }
                
                @media (prefers-contrast: more) {
                    :root {
                        --text: #111111;
                        --muted: #2b2f36;
                        --border: #6b7280;
                        --link: #0a3ea9;
                        --code-bg: #e5e7eb;
                        --code-text: #111111;
                    }
                }
                
                @media (prefers-color-scheme: dark) and (prefers-contrast: more) {
                    :root {
                        --text: #ffffff;
                        --muted: #e5e7eb;
                        --border: #7c818a;
                        --link: #9cc7ff;
                        --code-bg: #0b0f14;
                        --code-text: #ffffff;
                    }
                }
                
                body {
                    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
                    font-size: 16px;
                    line-height: 1.6;
                    padding: 2rem;
                    background-color: var(--bg);
                    color: var(--text);
                    max-width: 900px;
                    margin: 0 auto;
                }
                
                /* Typography */
                h1, h2, h3, h4, h5, h6 {
                    margin-top: 1.5em;
                    margin-bottom: 0.5em;
                    font-weight: 600;
                    line-height: 1.25;
                }
                
                h1 {
                    font-size: 2em;
                    border-bottom: 1px solid var(--border);
                    padding-bottom: 0.3em;
                }
                
                h2 {
                    font-size: 1.5em;
                    border-bottom: 1px solid var(--border);
                    padding-bottom: 0.3em;
                }
                
                h3 { font-size: 1.25em; }
                h4 { font-size: 1em; }
                h5 { font-size: 0.875em; }
                h6 { font-size: 0.85em; color: var(--muted); }
                
                /* Lists */
                ul, ol {
                    margin-bottom: 1em;
                    padding-left: 2em;
                }
                
                li {
                    margin-bottom: 0.25em;
                }
                
                /* Links */
                a {
                    color: var(--link);
                    text-decoration: none;
                }
                
                a:hover {
                    text-decoration: underline;
                }
                
                /* Paragraphs */
                p {
                    margin-bottom: 1em;
                }
                
                /* Code */
                code {
                    background-color: var(--code-bg);
                    color: var(--code-text);
                    padding: 0.2em 0.4em;
                    border-radius: 3px;
                    font-family: "SF Mono", Monaco, Menlo, Consolas, monospace;
                    font-size: 0.9em;
                }
                
                pre {
                    background-color: var(--code-bg);
                    border-radius: 6px;
                    padding: 1em;
                    overflow-x: auto;
                    margin-bottom: 1em;
                    border: 1px solid var(--border);
                }
                
                pre code {
                    background-color: transparent;
                    padding: 0;
                    font-size: 0.85em;
                    line-height: 1.45;
                }
                
                /* Blockquotes */
                blockquote {
                    border-left: 4px solid var(--border);
                    padding-left: 1em;
                    color: var(--muted);
                    margin-bottom: 1em;
                }
                
                /* Images */
                img {
                    max-width: 100%;
                    height: auto;
                    display: block;
                    margin: 1em 0;
                }
                
                /* Tables */
                table {
                    border-collapse: collapse;
                    width: 100%;
                    margin-bottom: 1em;
                }
                
                table tr {
                    background-color: var(--bg);
                    border-top: 1px solid var(--border);
                }
                
                table tr:nth-child(2n) {
                    background-color: var(--table-alt);
                }
                
                table th,
                table td {
                    padding: 0.5em 1em;
                    border: 1px solid var(--border);
                }
                
                table th {
                    font-weight: 600;
                }
                
                /* Horizontal rule */
                hr {
                    height: 2px;
                    padding: 0;
                    margin: 1.5em 0;
                    background-color: var(--border);
                    border: 0;
                }
                
                /* Task lists */
                input[type="checkbox"] {
                    margin-right: 0.5em;
                }
            </style>
        </head>
        <body>
            <div id="content"></div>
            <script>
                const markdown = \(jsonEncodedString(markdown));
                
                const content = document.getElementById('content');
                if (typeof marked !== 'undefined') {
                    marked.setOptions({
                        breaks: true,
                        gfm: true
                    });
                    content.innerHTML = marked.parse(markdown);
                } else {
                    content.textContent = markdown;
                }
            </script>
        </body>
        </html>
        """
    }
    
    private static func jsonEncodedString(_ markdown: String) -> String {
        guard
            let data = try? JSONSerialization.data(withJSONObject: markdown, options: []),
            let json = String(data: data, encoding: .utf8)
        else {
            return "\"\""
        }
        return json
    }
}
