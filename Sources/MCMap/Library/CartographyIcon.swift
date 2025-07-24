//
//  CartographyIcon.swift
//  MCMap
//
//  Created by Marquis Kurt on 21-07-2025.
//

import Foundation

/// An enumeration of custom icons that can be used in a `.mcmap` package.
public enum CartographyIcon: String, SendableCoded {
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
}
