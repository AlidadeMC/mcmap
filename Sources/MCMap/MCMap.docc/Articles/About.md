# About the MCMap Format

Read and understand the origins of the `.mcmap` package format and why it
exists.

## Overview

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
