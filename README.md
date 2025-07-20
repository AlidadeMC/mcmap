# Minecraft Map Packages (.mcmap)

The **Minecraft map package (.mcmap)** is a file package format designed
to store basic information about a Minecraft world and player-created
content.

This Swift package provides the interfaces for interacting with the
package format, allowing developers to read from and write to the format
easily in their apps. It is primary designed to be compatible with SwiftUI
based applications, and it is one of the tenet packages that makes the
Alidade app possible.

> **Important**  
> The file format is undergoing a refactor, and it currently uses the
> experimental v2 of the format. The format may change over time and is
> not representative of the final version of the v2 format.

## Getting started

To add the package to your project, add the following to your package
dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/AlidadeMC/mcmap.git", branch: "main")
]
```
 Alternatively, you can use Xcode's native interface for adding the
 dependency to your Swift project.
 
 ## License
 
 The file format and this package's implementation is free and open-source
 software licensed under the Mozilla Public License, v2.0. For more
 information on your rights, refer to the LICENSE.txt file in this
 repository.
