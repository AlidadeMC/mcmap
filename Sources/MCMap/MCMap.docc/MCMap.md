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

## Topics

### Getting Started

- <doc:Changelog>

### File Format

- <doc:About>
- <doc:Versions>
- ``CartographyMapFile``
- ``CartographyMapPin``
- ``CartographyDrawing``

### Manifest Versions

- ``MCMapManifest``
- ``MCMapManifest_PreVersioning``
- ``MCMapManifest_v1``
- ``MCMapManifest_v2``
- ``CartographyMapVersionSpec``

### Service Integrations

- ``CartographyMapIntegration``
- ``MCMapBluemapIntegration``

### Semantic Types

- ``CartographyIcon``
