#!/usr/bin/env swift

import CoreGraphics
import Foundation
import ImageIO
import UniformTypeIdentifiers

let dpi: CGFloat = 600
let canvasWidth = 3600
let canvasHeight = 2400
let tileSize = 1200

func printUsage() {
    let script = (CommandLine.arguments.first as NSString?)?.lastPathComponent ?? "make_4x6_sheet.swift"
    FileHandle.standardError.write(Data("Usage: \(script) <input-image> [output-image]\n".utf8))
}

guard CommandLine.arguments.count >= 2 else {
    printUsage()
    exit(1)
}

let inputURL = URL(fileURLWithPath: CommandLine.arguments[1])
let outputURL = URL(fileURLWithPath: CommandLine.arguments.count >= 3 ? CommandLine.arguments[2] : "output_4x6_sheet.jpg")

guard let source = CGImageSourceCreateWithURL(inputURL as CFURL, nil),
      let image = CGImageSourceCreateImageAtIndex(source, 0, nil) else {
    FileHandle.standardError.write(Data("Could not open image: \(inputURL.path)\n".utf8))
    exit(1)
}

let sourceWidth = image.width
let sourceHeight = image.height
let squareEdge = min(sourceWidth, sourceHeight)
let cropX = (sourceWidth - squareEdge) / 2
let cropY = (sourceHeight - squareEdge) / 2

guard let cropped = image.cropping(to: CGRect(x: cropX, y: cropY, width: squareEdge, height: squareEdge)) else {
    FileHandle.standardError.write(Data("Could not crop source image.\n".utf8))
    exit(1)
}

let colorSpace = CGColorSpaceCreateDeviceRGB()
let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue

guard let context = CGContext(
    data: nil,
    width: canvasWidth,
    height: canvasHeight,
    bitsPerComponent: 8,
    bytesPerRow: 0,
    space: colorSpace,
    bitmapInfo: bitmapInfo
) else {
    FileHandle.standardError.write(Data("Could not create output canvas.\n".utf8))
    exit(1)
}

context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
context.fill(CGRect(x: 0, y: 0, width: canvasWidth, height: canvasHeight))
context.interpolationQuality = .high

for row in 0..<2 {
    for column in 0..<3 {
        let x = CGFloat(column * tileSize)
        let y = CGFloat(canvasHeight - ((row + 1) * tileSize))
        context.draw(
            cropped,
            in: CGRect(x: x, y: y, width: CGFloat(tileSize), height: CGFloat(tileSize))
        )
    }
}

guard let outputImage = context.makeImage() else {
    FileHandle.standardError.write(Data("Could not finalize output image.\n".utf8))
    exit(1)
}

try FileManager.default.createDirectory(
    at: outputURL.deletingLastPathComponent(),
    withIntermediateDirectories: true,
    attributes: nil
)

guard let destination = CGImageDestinationCreateWithURL(
    outputURL as CFURL,
    UTType.jpeg.identifier as CFString,
    1,
    nil
) else {
    FileHandle.standardError.write(Data("Could not create JPEG destination.\n".utf8))
    exit(1)
}

let properties: [CFString: Any] = [
    kCGImageDestinationLossyCompressionQuality: 0.95,
    kCGImagePropertyDPIWidth: dpi,
    kCGImagePropertyDPIHeight: dpi
]

CGImageDestinationAddImage(destination, outputImage, properties as CFDictionary)

guard CGImageDestinationFinalize(destination) else {
    FileHandle.standardError.write(Data("Could not write output image.\n".utf8))
    exit(1)
}

print("Saved 4x6 passport sheet to \(outputURL.path)")
