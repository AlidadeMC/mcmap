# ``CartographyMapFeatures``

As the file format grows, some features may be added and removed, and it
might become cumbersome to determine which features are available from the
version number. To address this, this type can be used instead.

In ``CartographyMapFile``, this can be easily accessed via
``CartographyMapFile/supportedFeatures``.

### Querying features

To query for a specific feature, use the ``contains(_:)`` method provided:

```swift
let file: CartographyMapFile = ...

if file.supportedFeatures.contains(.pinTagging) {
    ...
}
```
