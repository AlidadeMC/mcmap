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
    ///
    /// - SeeAlso: For a list of all the potential use cases, refer to the ``CartographyIconContext``.
    case `default`

    // Buildings
    case home, building, town, mecca, tent, lodge

    // Transportation
    case bus, tram, walking, signpost

    // Objects
    case duffleBag, book, medal, trophy, beachUmbrella, flag, flashlight, camera, bag, cart, dice, wrench, briefcase,
        bed, coffee, chair, fireplace, washer, syringe, pill, bandage, teddyBear, carrot, forkAndKnife

    // Shapes
    case circle, square, rectangle, capsule, oval, triangle, diamond, octagon, hexagon, pentagon, seal
    
    // Misc.
    case sparklyBubbles, theaterMasks, puzzlePiece, film, cube
}

extension CartographyIcon: CaseIterable {}
