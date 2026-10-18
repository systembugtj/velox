# RFC 0007: Bundle Metadata Fields

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Expose standard application metadata fields through Velox configuration and write them into generated platform bundles.

## Problem

`BundleConfig` in `Sources/VeloxRuntime/Config.swift` lacks category, short and long descriptions, homepage, license, and copyright values.

## Goals

Carry optional metadata from decoded configuration into bundle metadata, with existing defaults unchanged.

## Non-goals

Config format support and platform-specific signing metadata are out of scope.

## Design

Add optional Codable fields to `BundleConfig` and map them in `Sources/VeloxBundler/Bundler.swift` to supported platform metadata keys. Omitted fields must not change existing bundle output. Define which fields each platform supports and emit actionable diagnostics for unsupported fields instead of silently inventing mappings.

## Acceptance

Config round-trip tests cover each field. Bundle fixture tests inspect generated metadata for supported mappings and confirm omitted fields preserve current output.
