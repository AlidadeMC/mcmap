//
//  StringExtensionTests.swift
//  MCMap
//
//  Created by Marquis Kurt on 24-07-2025.
//

import Testing

@testable import MCMap

struct StringExtensionTests {
    @Test func stringDotCase() async throws {
        #expect("beachUmbrella".dotCase == "beach.umbrella")
        #expect("multilineCharacterProperties".dotCase == "multiline.character.properties")
        #expect("SomehowPascalCase".dotCase == "somehow.pascal.case")
    }
}
