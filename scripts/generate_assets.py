#!/usr/bin/env python3
import os
import struct
import zlib


def write_png(path, width, height, pixels):
    raw = bytearray()
    stride = width * 4
    for y in range(height):
        raw.append(0)
        start = y * stride
        raw.extend(pixels[start:start + stride])

    def chunk(tag, data):
        return struct.pack("!I", len(data)) + tag + data + struct.pack("!I", zlib.crc32(tag + data) & 0xFFFFFFFF)

    ihdr = struct.pack("!IIBBBBB", width, height, 8, 6, 0, 0, 0)
    compressed = zlib.compress(bytes(raw), level=9)
    png = b"\x89PNG\r\n\x1a\n" + chunk(b"IHDR", ihdr) + chunk(b"IDAT", compressed) + chunk(b"IEND", b"")

    with open(path, "wb") as f:
        f.write(png)


def set_px(pixels, width, height, x, y, color):
    if 0 <= x < width and 0 <= y < height:
        i = (y * width + x) * 4
        pixels[i:i + 4] = bytes(color)


def fill_rect(pixels, width, height, x, y, w, h, color):
    for yy in range(y, y + h):
        for xx in range(x, x + w):
            set_px(pixels, width, height, xx, yy, color)


def draw_line(pixels, width, height, x0, y0, x1, y1, color, thickness=1):
    dx = abs(x1 - x0)
    dy = -abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx + dy
    while True:
        half = thickness // 2
        for yy in range(y0 - half, y0 + half + 1):
            for xx in range(x0 - half, x0 + half + 1):
                set_px(pixels, width, height, xx, yy, color)
        if x0 == x1 and y0 == y1:
            break
        e2 = 2 * err
        if e2 >= dy:
            err += dy
            x0 += sx
        if e2 <= dx:
            err += dx
            y0 += sy


FONT = {
    ".": [
        ".....",
        ".....",
        ".....",
        ".....",
        ".....",
        "..##.",
        "..##.",
    ],
    "m": [
        "#...#",
        "##.##",
        "#.#.#",
        "#...#",
        "#...#",
        "#...#",
        "#...#",
    ],
    "d": [
        "####.",
        "#...#",
        "#...#",
        "#...#",
        "#...#",
        "#...#",
        "####.",
    ],
}


def draw_text(pixels, width, height, text, x, y, scale, color):
    glyph_h = len(next(iter(FONT.values())))
    glyph_w = len(next(iter(FONT.values()))[0])
    spacing = 1 * scale
    cursor_x = x
    for ch in text:
        glyph = FONT.get(ch.lower())
        if glyph is None:
            cursor_x += (glyph_w + 1) * scale
            continue
        for row in range(glyph_h):
            for col in range(glyph_w):
                if glyph[row][col] == "#":
                    px = cursor_x + col * scale
                    py = y + row * scale
                    fill_rect(pixels, width, height, px, py, scale, scale, color)
        cursor_x += glyph_w * scale + spacing


def generate_icon(path):
    size = 1024
    pixels = bytearray([0, 0, 0, 0] * size * size)
    fill_rect(pixels, size, size, 0, 0, size, size, (26, 31, 40, 255))

    glyph_w = 5
    glyph_h = 7
    scale = int(size * 0.38 / glyph_h)
    text = ".md"
    text_w = (glyph_w * len(text) + (len(text) - 1)) * scale
    text_h = glyph_h * scale
    start_x = (size - text_w) // 2
    start_y = (size - text_h) // 2
    draw_text(pixels, size, size, text, start_x, start_y, scale, (255, 255, 255, 255))

    write_png(path, size, size, pixels)


def generate_dmg_background(path):
    width, height = 640, 400
    pixels = bytearray([0, 0, 0, 0] * width * height)
    fill_rect(pixels, width, height, 0, 0, width, height, (245, 246, 248, 255))

    arrow_color = (120, 128, 140, 255)
    center_y = int(height * 0.52)
    start_x = 240
    end_x = 400
    draw_line(pixels, width, height, start_x, center_y, end_x, center_y, arrow_color, thickness=6)
    draw_line(pixels, width, height, end_x, center_y, end_x - 18, center_y + 10, arrow_color, thickness=6)
    draw_line(pixels, width, height, end_x, center_y, end_x - 18, center_y - 10, arrow_color, thickness=6)

    write_png(path, width, height, pixels)


def main():
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    assets_dir = os.path.join(root, "assets")
    os.makedirs(assets_dir, exist_ok=True)

    icon_path = os.path.join(assets_dir, "icon-1024.png")
    dmg_path = os.path.join(assets_dir, "dmg-background.png")

    generate_icon(icon_path)
    generate_dmg_background(dmg_path)

    print("Generated:")
    print(icon_path)
    print(dmg_path)


if __name__ == "__main__":
    main()
