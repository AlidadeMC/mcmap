//
//  CartographyDrawing.swift
//  MCMap
//
//  Created by Marquis Kurt on 29-08-2025.
//

import Foundation
import PencilKit
import VersionedCodable

/// A representation of a player drawing that appears on a map.
///
/// Player drawings typically display as overlays on a map, similar to polylines, rectangles, or other standard map
/// overlays. These drawings are typically generated using the Apple Pencil (or a finger) through PencilKit on iPhone
/// and iPad, but they can be displayed on all platforms, including Mac.
public struct CartographyDrawing: SendableCoded, Identifiable {
    /// A representation of the drawing overlay.
    public struct DrawingOverlay: SendableCoded {
        /// A representation of the map region that the drawing occupies.
        public struct MapRect: SendableCoded {
            /// The x coordinate of the origin point.
            public var x: Int

            /// The z coordinate of the origin point.
            public var z: Int

            /// The width of the region.
            public var width: Int

            /// The height of the region
            public var height: Int

            /// Create a map region.
            public init(x: Int, z: Int, width: Int, height: Int) {
                self.x = x
                self.z = z
                self.width = width
                self.height = height
            }
        }

        /// The coordinate that represents the center of the map region.
        public var coordinate: CGPoint

        /// The drawing that the map region encompasses.
        public var drawing: PKDrawing

        /// The map region that encompasses the drawing.
        public var mapRect: MapRect

        public init(coordinate: CGPoint, drawing: PKDrawing, mapRect: MapRect) {
            self.coordinate = coordinate
            self.drawing = drawing
            self.mapRect = mapRect
        }
    }

    /// A unique identifier for the drawing overlay.
    public var id: UUID = UUID()

    /// The drawing overlay contents to send to a corresponding map.
    public var data: DrawingOverlay

    public init(id: UUID, data: DrawingOverlay) {
        self.id = id
        self.data = data
    }
}

extension CartographyDrawing: VersionedCodable {
    public typealias PreviousVersion = NothingEarlier

    /// The current version of the file format.
    public static let version: Int? = 1
}

extension CartographyDrawing.DrawingOverlay {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coordinate)
        hasher.combine(drawing.dataRepresentation())
        hasher.combine(mapRect)
    }
}
