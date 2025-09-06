# Minecraft Map Packages (.mcmap)

The **Minecraft map package (.mcmap)** is a file package format designed
to store basic information about a Minecraft world and player-created
content.

This Swift package provides the interfaces for interacting with the
package format, allowing developers to read from and write to the format
easily in their apps. It is primary designed to be compatible with SwiftUI
based applications, and it is one of the tenet packages that makes the
Alidade app possible.

> Note: This source code repository for MCMap is being migrated over to
> [SkyVault](https://source.marquiskurt.net/AlidadeMC/MCMap) as part of a
> larger effort to guarantee long-term sustainability, independent of
> GitHub. However, pull requests will still be accepted and welcomed on
> this mirror.

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
