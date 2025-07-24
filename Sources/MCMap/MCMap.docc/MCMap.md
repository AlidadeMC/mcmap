# ``MCMap``

Read and store information about a Minecraft world and player-generated
content.

## Overview

The **Minecraft map package (.mcmap)** is a file package format designed
to store basic information about a Minecraft world and player-created
content.

This Swift package provides the interfaces for interacting with the
package format, allowing developers to read from and write to the format
easily in their apps. It is primary designed to be compatible with SwiftUI
based applications, and it is one of the tenet packages that makes the
Alidade app possible.

> Important:
> The file format is undergoing a refactor, and it currently uses the
> experimental v2 of the format. The format may change over time and is
> not representative of the final version of the v2 format.

### About the MCMap Format

Minecraft worlds will generate differently based on the version being
played and the seed used to run the internal generation algorithms.
Players will often juggle between other worlds across devices and
versions, making re-entering this data particularly cumbersome. To address
this, the `.mcmap` package format was created to store this information
more easily.

#### Key Tenets

The `.mcmap` format has been carefully designed with the following key 
tenets in mind:

- **Portability**: The file format should be portable and easy to
  assemble.
- **Cross-platform**: Wherever possible, the file format should be
  designed to work across platforms, both within and outside of the Apple
  ecosystem.
- **Human-readable**: The format should be readable and inspectable to
  players.
- **Performant**: The file format should be performant to read from and
  write to.

## Topics

### File Format

- <doc:Versions>
- ``CartographyMapFile``
- ``CartographyMapPin``


### Manifest Versions

- ``MCMapManifest``
- ``MCMapManifest_PreVersioning``
- ``MCMapManifest_v1``
- ``MCMapManifest_v2``
- ``CartographyMapVersionSpec``

### Service Integrations

- ``MCMapIntegration``
- ``MCMapBluemapIntegration``

### Semantic Types

- ``CartographyIcon``
