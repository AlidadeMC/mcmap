//
//  IconResolution.swift
//  MCMap
//
//  Created by Marquis Kurt on 24-07-2025.
//

import SwiftUI

extension String {
    var dotCase: String {
        var newString = ""
        for character in self {
            guard character.isUppercase else {
                newString.append(character)
                continue
            }
            if !newString.isEmpty {
                newString.append(".")
            }
            newString.append(character.lowercased())
        }
        return newString
    }
}

/// A context for how a ``CartographyIcon`` is used.
public enum CartographyIconContext {
    /// The icon is used to describe a pinned place.
    case pin
}

public extension CartographyIcon {
    /// Resolve the semantic icon into an SF Symbol image from the given context.
    /// - Parameter context: The context that describes the semantic usage of the icon.
    func resolveSFSymbol(in context: CartographyIconContext) -> String {
        let defaultIcon = switch context {
        case .pin:
            "mappin"
        }

        switch self {
        case .default:
            return defaultIcon
        case .sparklyBubbles:
            return "bubbles.and.sparkles"
        case .town:
            return "building.2"
        case .home:
            return "house"
        case .walking:
            return "figure.walk"
        case .lodge:
            return "house.lodge"
        case .signpost:
            return "signpost.right"
        case .forkAndKnife:
            return "fork.knife"
        default:
            return rawValue.dotCase
        }
    }
}

public extension Image {
    /// Create an image from an icon within a provided context.
    ///
    /// Calling this initializer will generate the appropriate SF Symbol that can be used in labels, icons, and other
    /// parts of the interface. Some icons may have different appearances based on their semantic meanings defined in
    /// the context.
    /// - Parameter cartographyIcon: The icon to create an image of.
    /// - Parameter context: The context that describes the semantic usage of the icon.
    init(cartographyIcon: CartographyIcon, in context: CartographyIconContext) {
        self.init(systemName: cartographyIcon.resolveSFSymbol(in: context))
    }
}

public extension Label where Title == Text, Icon == Image {
    /// Create a label using a title and an icon within a provided context.
    ///
    /// Calling this initializer will generate the appropriate SF Symbol that can be used in labels, icons, and other
    /// parts of the interface. Some icons may have different appearances based on their semantic meanings defined in
    /// the context.
    ///
    /// - Parameter title: The label's title.
    /// - Parameter cartographyIcon: The icon to display in the label.
    /// - Parameter context: The context that describes the semantic usage of the icon.
    init(_ title: LocalizedStringKey, cartographyIcon: CartographyIcon, in context: CartographyIconContext) {
        self.init(title, systemImage: cartographyIcon.resolveSFSymbol(in: context))
    }
}
