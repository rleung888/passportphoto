# Passport Photo Sheet

This project creates a `4x6` photo print containing `6` copies of the same square image.

The intended workflow is:

1. Take a photo on your phone.
2. Crop it to a square image centered on your head.
3. Run the script.
4. Print the output as a regular `4x6` photo.
5. Cut out the six `2x2` photos.

## Output

The generated image is:

- `3600 x 2400` pixels
- `600 DPI`
- arranged as `3 across x 2 down`
- each tile is `1200 x 1200` pixels, which prints as `2 x 2` inches

## Required Files

To run this on another Mac or from a different directory, keep these two files together in the same folder:

- `make_4x6_sheet.swift`
- `run_passport_sheet.command`

You can move that folder anywhere you want. The `.command` launcher now finds the Swift script relative to its own location.

## Requirements

- macOS
- Swift available from Terminal

Check Swift with:

```bash
swift --version
```

## `.command` Permission

Yes. The `.command` file should be executable.

Set that once with:

```bash
chmod +x run_passport_sheet.command
```

After that, you can:

- double-click `run_passport_sheet.command` in Finder
- or run it in Terminal:

```bash
./run_passport_sheet.command
```

## Run From Terminal

If you want to run the Swift script directly:

```bash
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache swift make_4x6_sheet.swift input_square.jpg output.jpg
```

Example:

```bash
env CLANG_MODULE_CACHE_PATH=/tmp/clang-module-cache swift make_4x6_sheet.swift IMG_1539.jpg passport_sheet.jpg
```

## Run By Double-Clicking

Double-click `run_passport_sheet.command`.

It will prompt you for:

- the full path to your square image
- the output file name

The output file is saved in the same folder as the script.

## Notes

- The script center-crops the input image to a square if it is not already square.
- This project does not verify official passport compliance rules such as background, head size, lighting, or facial expression.
- For best print results, disable store auto-cropping or auto-enhancement if those options appear during checkout.
