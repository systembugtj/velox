# RFC 0026: macOS Release FFI Build Compatibility

**Status:** Approved

## Summary

Fix macOS release linking for Velox's Swift/C/Rust runtime bridge on Xcode 27. Preserve the current Swift API and runtime architecture.

## Problem

Release builds fail in two independent places: older Rust Mach-O stripping can produce a dylib rejected for an unaligned LINKEDIT string pool, and optimized Swift builds localize `@_cdecl` callback symbols required by the C shim. The latest upstream Velox checkout reproduces the Swift/C symbol failure after Rust stripping is disabled.

## Goals

Ensure Rust release artifacts remain linkable on macOS and keep both Swift callback entry points externally visible to the C shim.

## Non-goals

Removing Rust, replacing Tao/Wry, changing the FFI ABI, and changing application-facing APIs.

## Design

In `Plugins/VeloxRustBuildPlugin/VeloxRustBuildPlugin.swift`, disable Cargo release stripping for macOS release dependencies and build overrides. In `Sources/VeloxRuntimeWry/FFIEntryPoints.swift`, expose both `@_cdecl` callbacks as public symbols so optimized release linking retains their C names. Keep callback signatures and behavior unchanged.

## Acceptance

With Xcode 27 and Rust 1.97.1, build the `HelloWorld` product in release mode with Cargo strip overrides enabled by the plugin. Confirm the build resolves both C callback symbols and completes. Inspect resulting Mach-O LINKEDIT string-table alignment.
