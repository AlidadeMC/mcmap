//
//  CartographyIconTests.swift
//  MCMap
//
//  Created by Marquis Kurt on 22-07-2025.
//

import Foundation
import Testing

@testable import MCMap

struct CartographyIconTests {
    @Test func initFromRawValue() async throws {
        let defaultIcon = CartographyIcon(rawValue: "default")
        #expect(defaultIcon == .default)

        let emojiIcon = CartographyIcon(rawValue: "🚗")
        #expect(emojiIcon == .emoji("🚗"))

        let noIcon = CartographyIcon(rawValue: "foo")
        #expect(noIcon == nil)
    }

    @Test func decodeToRawValue() async throws {
        let defaultIcon = CartographyIcon.default
        #expect(defaultIcon.rawValue == "default")

        let emojiIcon = CartographyIcon.emoji("🚗")
        #expect(emojiIcon.rawValue == "🚗")
    }
}
