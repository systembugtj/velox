# RFC 0021: Windows Bundling Targets

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add Windows installer targets for NSIS and MSI/WiX with explicit signing and WebView2 runtime modes.

## Problem

The bundler supports only `app` and `dmg`; Windows apps lack generated installers and declared runtime prerequisites.

## Goals

Define Windows target configuration, installer content, signing inputs, and WebView2 installation policy.

## Non-goals

Linux installers, hosted signing, and automatic certificate issuance are out of scope.

## Design

Add target and signing/runtime configuration to `Sources/VeloxRuntime/Config.swift`; implement a Windows-specific backend isolated from macOS bundling. Invoke supported NSIS and WiX tooling through direct process APIs with argument arrays, validate tools and signing inputs before writing artifacts, and define offline/online WebView2 modes. Never log private key material. Keep signing optional for local development and explicit for release builds.

## Acceptance

Windows CI creates NSIS and MSI artifacts, verifies install/uninstall and executable launch, tests missing tooling and signing failures, and checks WebView2 modes. macOS bundle outputs remain unchanged.
