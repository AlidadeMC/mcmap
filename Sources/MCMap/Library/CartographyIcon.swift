//
//  CartographyIcon.swift
//  MCMap
//
//  Created by Marquis Kurt on 21-07-2025.
//

import Foundation

/// An enumeration of custom icons that can be used in a `.mcmap` package.
public enum CartographyIcon: RawRepresentable, SendableCoded {
    /// The default or generic icon.
    ///
    /// This icon might be represented differently depending on the context it's used in. For example, this might
    /// appear as a map pin when used in ``CartographyMapPin``, and as a folder or grid in a group.
    case `default`

    /// An icon that displays a house or home.
    case home

    /// An icon that displays a single building.
    case building

    /// An icon that displays a book.
    case book

    /// An icon that displays a town or multiple buildings together.
    case town

    /// An icon that displays bubbles surrounded by sparkles.
    case sparklyBubbles

    /// An icon that displays a single emoji character.
    ///
    /// > Important: When creating an icon from ``init(rawValue:)``, strings that don't contain emojis or only contain
    /// > partial emojis are discounted.
    case emoji(String)

    public init?(rawValue: String) {
        switch rawValue {
        case "default":
            self = .default
        case "home":
            self = .home
        case "building":
            self = .building
        case "sparklyBubbles":
            self = .sparklyBubbles
        case "town":
            self = .town
        case "book":
            self = .book
        case rawValue where rawValue.unicodeScalars.allSatisfy(\.properties.isEmoji):
            self = .emoji(rawValue)
        default:
            return nil
        }
    }

    public var rawValue: String {
        switch self {
        case .default: "default"
        case .home: "home"
        case .building: "building"
        case .sparklyBubbles: "sparklyBubbles"
        case .town: "town"
        case .book: "book"
        case .emoji(let emojiString): emojiString
        }
    }
}
