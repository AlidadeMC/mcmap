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

        let noIcon = CartographyIcon(rawValue: "foo")
        #expect(noIcon == nil)
    }

    @Test func decodeToRawValue() async throws {
        let defaultIcon = CartographyIcon.default
        #expect(defaultIcon.rawValue == "default")
    }

    @Test func iconResolution() async throws {
        #expect(CartographyIcon.beachUmbrella.resolveSFSymbol(in: .pin) == "beach.umbrella")
        #expect(CartographyIcon.forkAndKnife.resolveSFSymbol(in: .pin) == "fork.knife")

        let semanticDefault = CartographyIcon.default
        #expect(semanticDefault.resolveSFSymbol(in: .pin) == "mappin")
    }
}
