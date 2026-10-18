# RFC 0002: Tray Icon Image Support

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add a source-compatible Swift and FFI API for setting a system tray icon from an image path or image data, including initial configuration.

## Problem

`VeloxTrayConfig` and the runtime FFI lack an initial icon value and runtime setter, so apps cannot reliably display or replace tray imagery.

## Goals

Support configured initial icons and runtime icon changes through the Swift tray API and Rust/Swift bridge.

## Non-goals

Template generation, menu-item behavior, and non-macOS tray support are out of scope.

## Design

Extend `VeloxTrayConfig` with an optional icon representation and add `setIcon`/`setIconPath` on the Swift tray handle. Carry the value through `runtime-wry-ffi/src/lib.rs` with an additive FFI entry point. Decode and validate image input at the native boundary; retain current behavior when no icon is configured. Keep existing initializers source-compatible with defaulted parameters.

## Acceptance

Swift tests verify initial icon propagation, replacement, invalid/missing path errors, and no-icon compatibility. FFI tests verify payload ownership and error propagation. Build and run tray tests on macOS; document unsupported platform behavior if backend cannot render icons.
