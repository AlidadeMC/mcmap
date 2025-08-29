//
//  CartographyMapFile+FileDocument.swift
//  MCMap
//
//  Created by Marquis Kurt on 24-07-2025.
//

import SwiftUI
import UniformTypeIdentifiers

extension CartographyMapFile: FileDocument {
    public static var readableContentTypes: [UTType] { [.mcmap] }

    static func jsonEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        return encoder
    }

    /// Creates a file from a read configuration.
    ///
    /// - Note: This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to read the file from.
    public init(configuration: ReadConfiguration) throws {
        try self.init(fileWrappers: configuration.file.fileWrappers)
    }

    /// Creates a file from a series of file wrappers.
    /// - Parameter fileWrappers: The file wrappers to read the file from.
    init(fileWrappers: [String: FileWrapper]?) throws {
        guard let metadata = fileWrappers?[Keys.metadata], let metadataContents = metadata.regularFileContents else {
            throw CocoaError(CocoaError.fileReadCorruptFile)
        }
        let decoder = JSONDecoder()
        self.manifest = try decoder.decode(versioned: MCMapManifest.self, from: metadataContents)
        self.pins = []

        // Migrate pins out of the manifest, and into their own block.
        if supportedFeatures.contains(.separateLibrary) {
            migratePinDataIfNecessary()
            if let library = fileWrappers?[Keys.library], library.isDirectory {
                try loadLibrary(wrapper: library)
            }
        }

        // Sort entries alphabetically.
        self.pins.sort { lhs, rhs in
            lhs.name.lowercased() < rhs.name.lowercased()
        }

        if let imagesDir = fileWrappers?[Keys.images], imagesDir.isDirectory, let wrappers = imagesDir.fileWrappers {
            self.images = wrappers.reduce(into: [:]) { (imageMap, kvPair) in
                let (key, wrapper) = kvPair
                guard let data = wrapper.regularFileContents else { return }
                imageMap[key] = data
            }
        }

        self.appState = AppState()
        if let asDir = fileWrappers?[Keys.appState], asDir.isDirectory, let wrappers = asDir.fileWrappers {
            if let tabCustomizationFile = wrappers[Keys.appStateTabs]?.regularFileContents {
                let decoder = JSONDecoder()
                appState.tabCustomization = try decoder.decode(TabViewCustomization.self, from: tabCustomizationFile)
            }
        }

        self.integrations = Integrations()
        if let intDir = fileWrappers?[Keys.integrations], intDir.isDirectory, let wrappers = intDir.fileWrappers {
            if let bluemap = wrappers[MCMapBluemapIntegration.integrationKey]?.regularFileContents {
                let decoder = JSONDecoder()
                integrations.bluemap = try decoder.decode(MCMapBluemapIntegration.self, from: bluemap)
            }
        }
    }

    mutating func migratePinDataIfNecessary() {
        if manifest.pins.isEmpty { return }
        self.pins = manifest.pins.map(CartographyMapPin.init(migratingFrom:))
        manifest.pins = []
    }

    mutating func loadLibrary(wrapper library: FileWrapper) throws {
        if let pins = library.fileWrappers?[Keys.pins], pins.isDirectory, let pinFiles = pins.fileWrappers {
            let newPins = try pinFiles.reduce(into: [CartographyMapPin]()) { (accum, kvPair) in
                let (_, wrapper) = kvPair
                guard let data = wrapper.regularFileContents else { return }
                let decoded = try JSONDecoder().decode(versioned: CartographyMapPin.self, from: data)
                accum.append(decoded)
            }
            self.pins.append(contentsOf: newPins)
        }

        guard supportedFeatures.contains(.drawings) else { return }
        if let drawings = library.fileWrappers?[Keys.drawings], drawings.isDirectory,
            let drawingFiles = drawings.fileWrappers
        {
            let drawings = try drawingFiles.reduce(into: [CartographyDrawing]()) { partialResult, kvPair in
                let (_, wrapper) = kvPair
                guard let data = wrapper.regularFileContents else { return }
                let decoded = try JSONDecoder().decode(versioned: CartographyDrawing.self, from: data)
                partialResult.append(decoded)
            }
            self.drawings.append(contentsOf: drawings)
        }
    }

    /// Creates a file wrapper from a write configuration.
    ///
    /// - Note:This is only used via SwiftUI, and it cannot be tested or invoked manually.
    ///
    /// - Parameter configuration: The configuration to write the file to.
    public func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return try wrapper()
    }

    /// Creates a file wrapper regardless of configuration.
    ///
    /// - Note: This is mostly used by SwiftUI, but it exists as a standalone method for testing purposes.
    func wrapper() throws -> FileWrapper {
        let encodedMetadata = try prepareMetadataForExport()
        let metadataWrapper = FileWrapper(regularFileWithContents: encodedMetadata)

        var imageWrappers = [String: FileWrapper]()
        for (key, data) in self.images {
            imageWrappers[key] = FileWrapper(regularFileWithContents: data)
        }

        let imagesDirectoryWrapper = FileWrapper(directoryWithFileWrappers: imageWrappers)

        let fileWrapper = FileWrapper(directoryWithFileWrappers: [
            Keys.metadata: metadataWrapper,
            Keys.images: imagesDirectoryWrapper,
        ])

        var appStateWrapperFiles = [String: FileWrapper]()
        if supportedFeatures.contains(.tabCustomization) {
            let tabData = try Self.jsonEncoder().encode(appState.tabCustomization)
            appStateWrapperFiles[Keys.appStateTabs] = FileWrapper(regularFileWithContents: tabData)
        }

        var integrationsWrapperFiles = [String: FileWrapper]()
        if supportedFeatures.contains(.integrations) {
            let bluemap = try Self.jsonEncoder().encode(integrations.bluemap)
            integrationsWrapperFiles[MCMapBluemapIntegration.integrationKey] = FileWrapper(
                regularFileWithContents: bluemap
            )
        }

        var pinWrapperFiles = [String: FileWrapper]()
        if supportedFeatures.contains(.separateLibrary) {
            for pin in self.pins {
                let filename = pin.name + ".json"
                let encoded = try Self.jsonEncoder().encode(versioned: pin)
                pinWrapperFiles[filename] = FileWrapper(regularFileWithContents: encoded)
            }
        }

        var drawingFiles = [String: FileWrapper]()
        if !supportedFeatures.intersection([.separateLibrary, .drawings]).isEmpty {
            for drawing in self.drawings {
                let filename = drawing.id.uuidString + ".json"
                let encoded = try Self.jsonEncoder().encode(versioned: drawing)
                drawingFiles[filename] = FileWrapper(regularFileWithContents: encoded)
            }
        }

        if supportedFeatures != .minimumDefault {
            let appStateWrapper = FileWrapper(directoryWithFileWrappers: appStateWrapperFiles)
            appStateWrapper.preferredFilename = Keys.appState
            fileWrapper.addFileWrapper(appStateWrapper)

            let integrationsWrapper = FileWrapper(directoryWithFileWrappers: integrationsWrapperFiles)
            integrationsWrapper.preferredFilename = Keys.integrations
            fileWrapper.addFileWrapper(integrationsWrapper)

            let pinWrappers = FileWrapper(directoryWithFileWrappers: pinWrapperFiles)
            let drawingWrappers = FileWrapper(directoryWithFileWrappers: drawingFiles)

            let library = FileWrapper(directoryWithFileWrappers: [
                Keys.pins: pinWrappers,
                Keys.drawings: drawingWrappers
            ])
            library.preferredFilename = Keys.library
            fileWrapper.addFileWrapper(library)
        }

        return fileWrapper
    }
}
