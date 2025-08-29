//
//  MCMapsTests.swift
//  MCMapsTests
//
//  Created by Marquis Kurt on 31-01-2025.
//

import PencilKit
import SwiftUI
import Testing

@testable import MCMap

struct CartographyMapFileTests {
    @Test func initEmpty() async throws {
        let file = CartographyMapFile(withManifest: .sampleFile)

        #expect(file.manifest == .sampleFile)
    }

    @Test func initFromData() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)

        #expect(file.manifest.name == "Pack.mcmeta")
        #expect(file.manifest.worldSettings.version == "1.2")
        #expect(file.manifest.worldSettings.seed == 3_257_840_388_504_953_787)
        #expect(file.pins.count == 2)
        #expect(file.manifest.recentLocations?.count == 1)
    }

    @Test func initFromFileWrappers() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        guard let mapStripped = Self.packMcmetaFile_V2_StrippedPins.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }

        var file = try CartographyMapFile(decoding: map)
        file.images = ["foo.png": Data()]
        file.drawings = [
            CartographyDrawing(
                data: CartographyDrawing.DrawingOverlay(
                    coordinate: CGPoint(x: 37, y: -122),
                    drawing: PKDrawing(),
                    mapRect: CartographyDrawing.DrawingOverlay.MapRect(
                        x: 37,
                        z: -122,
                        width: 5,
                        height: 5
                    )
                )
            )
        ]
        let wrapper = try file.wrapper()

        let manifestWithStrippedPins = try JSONDecoder().decode(versioned: MCMapManifest.self, from: mapStripped)

        let newFile = try CartographyMapFile(fileWrappers: wrapper.fileWrappers)
        #expect(newFile.manifest == manifestWithStrippedPins)
        #expect(newFile.images == ["foo.png": Data()])
        #expect(!newFile.drawings.isEmpty)
    }

    @Test func preparesForExport() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()

        #expect(exported == map)
    }

    @Test func handlesMigrationToV2() async throws {
        guard let map = Self.packMcmetaFile_V1.data(using: .utf8),
              let mapV2 = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        let file = try CartographyMapFile(decoding: map)
        let exported = try file.prepareMetadataForExport()
        
        #expect(exported == mapV2)
    }

    @Test func fileWrapper() async throws {
        guard let map = Self.packMcmetaFile_V2.data(using: .utf8) else {
            Issue.record("Failed to convert to a Data object.")
            return
        }
        var file = try CartographyMapFile(decoding: map)
        file.images = ["foo.png": Data()]
        file.appState.tabCustomization = TabViewCustomization()
        file.drawings = [
            CartographyDrawing(
                data: CartographyDrawing.DrawingOverlay(
                    coordinate: CGPoint(x: 37, y: -122),
                    drawing: PKDrawing(),
                    mapRect: CartographyDrawing.DrawingOverlay.MapRect(
                        x: 37,
                        z: -122,
                        width: 5,
                        height: 5
                    )
                )
            )
        ]
    
        let wrapper = try file.wrapper()

        #expect(wrapper.isDirectory == true)
        #expect(wrapper.fileWrappers?["Info.json"] != nil)
        #expect(wrapper.fileWrappers?["Images"] != nil)
        #expect(wrapper.fileWrappers?["AppState"] != nil)
        #expect(wrapper.fileWrappers?["Library"] != nil)

        let infoWrapper = wrapper.fileWrappers?["Info.json"]!
        #expect(infoWrapper?.isRegularFile == true)
        #expect(infoWrapper?.regularFileContents == map)

        let imagesWrapper = wrapper.fileWrappers?["Images"]!
        #expect(imagesWrapper?.isDirectory == true)
        #expect(imagesWrapper?.fileWrappers?["foo.png"] != nil)

        let appStateWrapper = wrapper.fileWrappers?["AppState"]!
        #expect(appStateWrapper?.isDirectory == true)
        #expect(appStateWrapper?.fileWrappers?["Tabs.json"] != nil)

        let integrations = wrapper.fileWrappers?["Integrations"]!
        #expect(integrations?.isDirectory == true)
        #expect(integrations?.fileWrappers?["Bluemap.json"] != nil)

        let library = wrapper.fileWrappers?["Library"]!
        #expect(library?.isDirectory == true)
        #expect(library?.fileWrappers?["Pins"] != nil)
        #expect(library?.fileWrappers?["Drawings"] != nil)

        let pins = try #require(library?.fileWrappers?["Pins"])
        #expect(pins.isDirectory == true)
        #expect(pins.fileWrappers?.count == 2)

        let drawings = try #require(library?.fileWrappers?["Drawings"])
        #expect(drawings.isDirectory == true)
        #expect(drawings.fileWrappers?.count == 1)
    }

    @Test func pinDeletesAtIndex() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data()
        ])
        file.pins[0].images = ["foo.png"]
        file.removePinFromLibrary(at: file.pins.startIndex)
        #expect(file.images["foo.png"] == nil)
        #expect(file.images.isEmpty)
        #expect(file.pins.isEmpty)
    }

    @Test func pinDeletesAtOffsets() async throws {
        var file = CartographyMapFile(withManifest: .sampleFile, images: [
            "foo.png": Data(),
            "bar.png": Data()
        ])
        file.pins[0].images = ["foo.png"]
        file.pins.append(CartographyMapPin(named: "Don't delete me", at: CGPoint(x: 2, y: 2)))
        file.pins.append(CartographyMapPin(named: "Alt Point", at: .zero, images: ["bar.png"]))
        file.removePins(at: [0, 2])
        #expect(file.images.isEmpty)
        #expect(file.pins.count == 1)
        #expect(file.pins[0].name == "Don't delete me")
    }
}

extension CartographyMapFileTests {
    static let packMcmetaFile_V1 =
        """
        {
          "manifestVersion" : 1,
          "mcVersion" : "1.2",
          "name" : "Pack.mcmeta",
          "pins" : [
            {
              "name" : "Spawn",
              "position" : [
                0,
                0
              ]
            },
            {
              "color" : "brown",
              "name" : "Screenshot",
              "position" : [
                116,
                -31
              ]
            }
          ],
          "recentLocations" : [
            [
              116,
              -31
            ]
          ],
          "seed" : 3257840388504953787
        }
        """

    static let packMcmetaFile_V2 =
        """
        {
          "manifestVersion" : 2,
          "name" : "Pack.mcmeta",
          "pins" : [
            {
              "name" : "Spawn",
              "position" : [
                0,
                0
              ]
            },
            {
              "color" : "brown",
              "name" : "Screenshot",
              "position" : [
                116,
                -31
              ]
            }
          ],
          "recentLocations" : [
            [
              116,
              -31
            ]
          ],
          "world" : {
            "largeBiomes" : false,
            "seed" : 3257840388504953787,
            "version" : "1.2"
          }
        }
        """

    static let packMcmetaFile_V2_StrippedPins =
        """
        {
          "manifestVersion" : 2,
          "name" : "Pack.mcmeta",
          "pins" : [],
          "recentLocations" : [
            [
              116,
              -31
            ]
          ],
          "world" : {
            "largeBiomes" : false,
            "seed" : 3257840388504953787,
            "version" : "1.2"
          }
        }
        """
}
