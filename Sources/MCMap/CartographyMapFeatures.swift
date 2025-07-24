//
//  CartographyMapFeatures.swift
//  MCMaps
//
//  Created by Marquis Kurt on 19-06-2025.
//

import Foundation

/// An option set used to surface what features are supported by a MCMap package.
public struct CartographyMapFeatures: Sendable {
    /// The raw value representation.
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

extension CartographyMapFeatures: OptionSet {
    /// The file supports the core searching capabilities.
    ///
    /// This feature is available across all the file format versions.
    public static let coreSearch = CartographyMapFeatures(rawValue: 1 << 0)

    /// The file supports the core pinning capabilities.
    ///
    /// This feature is available across all the file format versions.
    public static let corePinning = CartographyMapFeatures(rawValue: 1 << 1)

    /// The file supports generating worlds with the "large biomes" feature.
    ///
    /// This feature is available from v2+ of the file format.
    public static let largeBiomes = CartographyMapFeatures(rawValue: 1 << 2)

    /// The file supports tags in pinned places.
    ///
    /// This feature is available from v2+ of the file format.
    public static let pinTagging = CartographyMapFeatures(rawValue: 1 << 3)

    /// The file supports tab customization app data.
    ///
    /// This feature is available from v2+ of the file format.
    public static let tabCustomization = CartographyMapFeatures(rawValue: 1 << 4)

    /// The file supports integrations with other services.
    ///
    /// This feature is available from v2+ of the file format.
    public static let integrations = CartographyMapFeatures(rawValue: 1 << 5)

    /// The file supports a separate player library instead of housing it in the manifest.
    ///
    /// This feature is available from v2+ of the file format.
    public static let separateLibrary = CartographyMapFeatures(rawValue: 1 << 6)

    /// The file supports custom icons for pins.
    ///
    /// This feature is available from v2+ of the file format.
    public static let pinIcons = CartographyMapFeatures(rawValue: 1 << 7)

    /// The default set of features for the minimum version supported.
    public static let minimumDefault: CartographyMapFeatures = [.coreSearch, .corePinning]

    /// Create a feature set from a file.
    public init(representing file: CartographyMapFile) {
        self = .minimumDefault

        guard let manifestVersion = file.manifest.manifestVersion else { return }
        switch manifestVersion {
        case 2...:
            self.insert(.pinTagging)
            self.insert(.largeBiomes)
            self.insert(.tabCustomization)
            self.insert(.integrations)
            self.insert(.separateLibrary)
            self.insert(.pinIcons)
        default:
            break
        }
    }
}
