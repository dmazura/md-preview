# Sample Markdown Document

This is a sample Markdown file to test the Quick Look extension.

## Features Showcase

### Text Formatting

This paragraph contains **bold text**, *italic text*, and even ***bold italic text***. You can also use ~~strikethrough~~ text.

### Lists

Unordered list:
- First item
- Second item
  - Nested item 1
  - Nested item 2
- Third item

Ordered list:
1. First step
2. Second step
3. Third step

### Code

Inline code: `const greeting = "Hello, World!";`

Code block:
```javascript
function fibonacci(n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

console.log(fibonacci(10));
```

```python
def greet(name):
    """A simple greeting function"""
    return f"Hello, {name}!"

print(greet("World"))
```

### Links and Images

[Visit GitHub](https://github.com)

Here's a placeholder image:
![Sample Image](https://via.placeholder.com/400x200/4A90E2/ffffff?text=Quick+Look+Preview)

### Blockquotes

> "The best way to predict the future is to invent it."
> 
> — Alan Kay

### Tables

| Feature | Status | Priority |
|---------|--------|----------|
| Dark Mode | ✅ Done | High |
| Syntax Highlighting | ✅ Done | High |
| GFM Support | ✅ Done | Medium |
| Custom Themes | ⏳ Planned | Low |

### Horizontal Rule

---

### Task Lists

- [x] Create project structure
- [x] Implement rendering
- [x] Add dark mode support
- [ ] Add syntax highlighting
- [ ] Bundle marked.js offline

## Technical Details

This Quick Look extension uses:

1. **SwiftUI** for the view layer
2. **WKWebView** for rendering HTML
3. **marked.js** for Markdown parsing
4. **CSS media queries** for dark mode

### Math (if supported)

Inline math might look like this: E = mc²

## Conclusion

This sample demonstrates most common Markdown features. Press **Space** in Finder to preview any `.md` file with this extension!

