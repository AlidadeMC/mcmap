//
//  Models.swift
//  MCMap
//
//  Created by Marquis Kurt on 21-07-2025.
//

/// A typealias that represents the minimum set of protocol requirements for codable data.
///
/// To ensure compatibility with Swift concurrency, certain types need to guarantee sendability. This typealias can be
/// used to clean up the implementation site by storing all the codable and sendable protocols into a single type.
public typealias SendableCoded = Sendable & Codable & Hashable
