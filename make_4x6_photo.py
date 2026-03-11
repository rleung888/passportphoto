#!/usr/bin/env python3

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageColor, ImageOps


DEFAULT_DPI = 300
PORTRAIT_SIZE = (1200, 1800)
LANDSCAPE_SIZE = (1800, 1200)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Convert an image into a printable 4x6 photo layout."
    )
    parser.add_argument("input", type=Path, help="Path to the source image.")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        default=Path("output_4x6.jpg"),
        help="Path for the generated 4x6 image.",
    )
    parser.add_argument(
        "--orientation",
        choices=("portrait", "landscape"),
        default="portrait",
        help="4x6 layout orientation. Default: portrait.",
    )
    parser.add_argument(
        "--background",
        default="white",
        help='Canvas background color. Examples: "white", "#f5f5f5", "black".',
    )
    parser.add_argument(
        "--margin",
        type=float,
        default=0.25,
        help="Margin in inches around the image. Default: 0.25.",
    )
    return parser.parse_args()


def crop_to_square(image: Image.Image) -> Image.Image:
    width, height = image.size
    edge = min(width, height)
    left = (width - edge) // 2
    top = (height - edge) // 2
    return image.crop((left, top, left + edge, top + edge))


def build_canvas(size: tuple[int, int], color: str) -> Image.Image:
    return Image.new("RGB", size, ImageColor.getrgb(color))


def main() -> None:
    args = parse_args()
    source = Image.open(args.input).convert("RGB")
    square = crop_to_square(source)

    canvas_size = PORTRAIT_SIZE if args.orientation == "portrait" else LANDSCAPE_SIZE
    canvas = build_canvas(canvas_size, args.background)

    margin_px = max(0, round(args.margin * DEFAULT_DPI))
    target_box = (
        canvas_size[0] - (margin_px * 2),
        canvas_size[1] - (margin_px * 2),
    )
    resized = ImageOps.contain(square, target_box, Image.Resampling.LANCZOS)

    x = (canvas.width - resized.width) // 2
    y = (canvas.height - resized.height) // 2
    canvas.paste(resized, (x, y))

    args.output.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(args.output, dpi=(DEFAULT_DPI, DEFAULT_DPI), quality=95)

    print(f"Saved 4x6 photo to {args.output}")


if __name__ == "__main__":
    main()
