# RFC 0019: Bundle File Associations

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow bundle configuration to declare file extensions and content types handled by the application.

## Problem

`bundle.fileAssociations` is unsupported, so generated bundles cannot advertise their document types to the operating system.

## Goals

Validate association metadata and emit platform bundle declarations for supported operating systems.

## Non-goals

File opening deep-link events and document editing APIs are out of scope.

## Design

Add Codable association models under bundle config in `Sources/VeloxRuntime/Config.swift`, including extensions, MIME/UTI or platform content type, role, and display name as needed. Map only well-defined values into macOS `Info.plist` in `Sources/VeloxBundler/Bundler.swift`; keep platform-specific mappings isolated for future bundlers. Reject malformed extensions and conflicting declarations.

## Acceptance

Tests cover config decoding, normalization, invalid/conflicting declarations, and generated plist document-type entries. Confirm omitted associations preserve current bundle output.
