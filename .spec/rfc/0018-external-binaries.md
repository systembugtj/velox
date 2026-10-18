# RFC 0018: External Bundle Binaries

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow bundle configuration to declare auxiliary executables that must ship beside the main application binary.

## Problem

`bundle.externalBin` is not modeled, so the bundler cannot stage helper executables as part of a release bundle.

## Goals

Copy and validate configured helper binaries into the platform-defined executable location with correct permissions.

## Non-goals

Plugin-managed process execution and platform-specific installer targets are out of scope.

## Design

Add an optional external-binary list to the bundle config in `Sources/VeloxRuntime/Config.swift`. Resolve each source relative to config root, validate regular-file existence and destination naming, then stage atomically in `Sources/VeloxBundler/Bundler.swift`. Preserve executable mode and reject destination collisions. Define behavior for symlinks and architecture mismatch before implementation.

## Acceptance

Config and bundler tests cover one/multiple binaries, missing source, collision, mode preservation, and failure cleanup. Inspect a produced bundle fixture to confirm final layout.
