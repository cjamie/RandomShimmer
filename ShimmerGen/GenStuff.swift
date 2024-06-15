//
//  GenStuff.swift
//  ShimmerGen
//
//  Created by Jamie Chu on 6/14/24.
//

import Gen
import SwiftUI

let largeInt = Gen.int(in: 30...40)
let charCount = Gen.int(in: 3...12)

let wordsGen = Gen
    .letter
    .string(of: charCount)
    .array(of: .frequency(
        (1, .always(15)),
        (1, .int(in: 6...12))
    ))

let wordsGen2 = Gen
    .letter
    .string(of: .frequency(
        (1, charCount)
//        (2, .int(in: 4...4))
    ))
    .array(
        of: .frequency(
            (1,  .int(in: 3...12)),
            (1, .int(in: 17...22))
        )
    )

let sentenceGen1 = wordsGen.map {
    $0.joined(separator: " ")
}

let sfSymbols1: [String] = [
    "star",
    "heart",
    "house",
    "gear",
    "trash",
    "magnifyingglass",
    "bell",
    "clock",
    "camera",
    "book"
]

let fontPresets: [Font] = [
    .body,
    .callout,
    .caption,
    .footnote,
    .headline,
    .subheadline,
    .largeTitle,
    .title,
    .title2,
    .title3,
    .system(size: 17),
    .system(size: 17, weight: .bold),
    .system(size: 20, weight: .semibold, design: .rounded)
]

func map<A, B>(
    _ f: @escaping (A) -> B
) -> ([A]) -> [B] {
    { $0.map(f) }
}

let sfSymbolGen = Gen
    .element(of: sfSymbols1).map { $0! }

let fontGen: Gen<Font> = Gen
    .element(of: fontPresets)
    .map { $0!.bold() }


let colorGen = Gen.color.map(Color.init(uiColor:))

let styledImageGen = zip(
    fontGen,
    sfSymbolGen,
    colorGen.map {$0.darker(by: 30) }
)
let styledImagesGen = styledImageGen
    .array(of: .always(10))
    .map(map(Generated.StyledImage.init(font:systemImageName:color:)))

let temp: Gen<Generated> = .frequency(
    (1, styledImagesGen.map(Generated.styledImages)),
    
    (1, sentenceGen1.map(Generated.caseRedactedText)),
    (2, zip(wordsGen2, .cgFloat(in: 2...16))
        .map(Generated.flexibleViews)
    )
)
