//
//  MCMapIntegration.swift
//  MCMapFormat
//
//  Created by Marquis Kurt on 12-07-2025.
//

import Foundation

/// A protocol that defines an integration supported by the `.mcmap` format.
///
/// Integrations are used to connect to external services to provide additional information. Depending on the client
/// implementation, this may include making network requests.
public protocol CartographyMapIntegration: Sendable, Codable, Hashable, Equatable {
    /// The key for the integration.
    ///
    /// This is used to register the file in the ``CartographyMapFile/Keys/integrations`` subdirectory.
    static var integrationKey: String { get }

    /// Whether the integration is enabled.
    ///
    /// Unless this integration is required out of the box, it is generally recommended to keep this as false by
    /// default.
    var enabled: Bool { get set }
}

