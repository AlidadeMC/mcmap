//
//  CartographyMapPin.swift
//  MCMap
//
//  Created by Marquis Kurt on 21-07-2025.
//

import Foundation
import VersionedCodable

/// A representation of a player-created pin.
///
/// In prior versions of the file format, these were stored in the `pins` property of the main manifest.
public struct CartographyMapPin: SendableCoded, Identifiable {
    public typealias Icon = CartographyIcon

    /// An enumeration of the color variants available for a pin.
    ///
    /// These colors generally map to corresponding system colors based on the implementation.
    public enum Color: String, SendableCoded {
        /// A red color.
        case red

        /// An orange color.
        case orange

        /// A yellow color.
        case yellow

        /// A green color.
        case green

        /// A blue color.
        case blue

        /// An indigo color.
        case indigo

        /// A gray color.
        case gray

        /// A pink color.
        case pink

        /// A brown color.
        case brown
    }

    /// The version of the map pin manifest.
    public static let version: Int? = 2

    /// A unique identifier for the pin.
    public var id: UUID

    /// The position where the pin is located on the map.
    ///
    /// The X coordinate maps to the Minecraft X coordinate, and the Y coordinate maps to the Minecraft Z coordinate.
    public var position: CGPoint

    /// The pin's name.
    public var name: String

    /// The pin's accent color.
    public var color: Color? = .blue

    /// The pin's icon.
    public var icon: Icon? = .default

    /// A description or set of notes associated with this pin.
    public var description: String = ""

    /// A set of image filenames associated with this pin.
    public var images: Set<String>? = []

    /// A set of tags associated with this pin.
    public var tags: Set<String>? = []

    /// A set of alternative IDs that correspond to this pin.
    ///
    /// If an integration recognizes this pin by a different ID, it will be visible here.
    public var alternateIDs: Set<String>?

    public init(
        named name: String,
        at position: CGPoint,
        color: Color? = .blue,
        icon: Icon? = .default,
        description: String? = "",
        images: Set<String>? = [],
        tags: Set<String>? = [],
        alternateIDs: Set<String>? = nil
    ) {
        self.name = name
        self.position = position
        self.id = UUID()

        self.color = color
        self.icon = icon
        self.description = description ?? ""
        self.images = images
        self.tags = tags
        self.alternateIDs = alternateIDs
    }
}

extension CartographyMapPin: VersionedCodable {
    /// A typealias pointing to the previous version of the pin format.
    ///
    /// Because this type was created outside of ``MCMapManifestPin``, there are no prior versions to migrate from.
    /// This is handled internally by ``CartographyMapFile``.
    public typealias PreviousVersion = NothingEarlier

    /// Create a pin by migrating an existing manifest pin.
    /// - Parameter priorVersion: The manifest pin to migrate from.
    public init(migratingFrom priorVersion: MCMapManifestPin) {
        self.name = priorVersion.name
        self.position = priorVersion.position
        self.color = CartographyMapPin.Color(rawValue: priorVersion.color?.rawValue ?? "") ?? .blue
        self.description = priorVersion.aboutDescription ?? ""
        self.images = Set(priorVersion.images ?? [])
        self.tags = priorVersion.tags

        self.id = UUID()
        self.icon = .default
    }
}
