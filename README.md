# Passport Photo Sheet

This project creates a `4x6` photo print containing `6` copies of the same square image.

The intended use case is:

1. Take a photo on your phone.
2. Crop it to a square image centered on your head.
3. Run the script.
4. Print the output as a regular `4x6` photo at a store such as CVS.
5. Cut out the six `2x2` photos.

## Output

The generated image is:

- `3600 x 2400` pixels
- `600 DPI`
- arranged as `3 across x 2 down`
- each tile is `1200 x 1200` pixels, which prints as `2 x 2` inches

## Files

- [make_4x6_sheet.swift](/Users/raymondleung/Documents/New project 2/make_4x6_sheet.swift): Swift script that generates the 6-up passport sheet
- [run_passport_sheet.command](/Users/raymondleung/Documents/New project 2/run_passport_sheet.command): double-clickable macOS launcher that prompts for an input image and output file name

## Run From Terminal

```bash
cd "/Users/raymondleung/Documents/New project 2"
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache swift make_4x6_sheet.swift input_square.jpg output.jpg
```

Example:

```bash
cd "/Users/raymondleung/Documents/New project 2"
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache swift make_4x6_sheet.swift IMG_1539.jpg IMG_1539_passport_4x6_600dpi.jpg
```

## Run By Double-Clicking

Double-click [run_passport_sheet.command](/Users/raymondleung/Documents/New project 2/run_passport_sheet.command) in Finder.

It will prompt you for:

- the full path to your square image
- the output file name

## Notes

- The script center-crops the input image to a square if it is not already square.
- This project does not verify official passport compliance rules such as background, head size, lighting, or facial expression.
- For best print results, disable store auto-cropping or auto-enhancement if those options appear during checkout.
