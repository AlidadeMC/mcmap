# ``CartographyIcon``

@Metadata {
    @Available("MCMap Format", introduced: "2.0")
}

Icons are typically provided in parts of manifests, such as with the
``CartographyMapPin``. They are generally coded as a string when applied
to Codable types and have corresponding symbols that match in SF Symbols.

> Important: When getting the appropriate SF Symbol for an icon, do not
> use the `rawValue` property. Instead, call the
> ``CartographyIcon/resolveSFSymbol(in:)`` method, as some icon names may
> not match to an SF Symbol directly.

This icon can also be used in SwiftUI with the appropriate initializers.
For example, to initialize an image:

```swift
import MCMap
import SwiftUI

struct MyImage: View {
    var body: some View {
        Image(cartographyIcon: .default, in: .pin)
    }
}
```

## Topics

### Semantic icons

Semantic icons don't provide a value on their own. Rather, they must be
provided through ``CartographyIcon/resolveSFSymbol(in:)``, as these types
of icons are semantic to the context they're applied to. For example, the
``CartographyIcon/default`` might refer to a map pin when in the semantic
context of pins.

- ``CartographyIconContext``
- ``CartographyIcon/resolveSFSymbol(in:)``
- ``CartographyIcon/default``

### Using Icons with SwiftUI

- ``SwiftUICore/Image/init(cartographyIcon:in:)``
- ``SwiftUI/Label/init(_:cartographyIcon:in:)``
