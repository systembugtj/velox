# RFC 0014: File System Plugin

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add an opt-in file system plugin with scoped, permission-checked file operations for webview callers.

## Problem

Velox lacks a built-in file system plugin, and direct native filesystem access must be constrained by application capabilities.

## Goals

Provide a small set of read, write, list, and metadata operations with paths restricted by configured scopes.

## Non-goals

File dialogs remain in the existing dialog plugin. Watchers, arbitrary process access, and unrestricted filesystem access are out of scope.

## Design

Create `VeloxPluginFileSystem` following existing plugin targets and re-export it from `VeloxPlugins.swift`. Implement operations with `FileManager` and `URL`, canonicalize paths before authorization, reject traversal and symlink escapes, and enforce read/write scopes through RFC 0004. Return structured errors without leaking unrelated filesystem contents.

## Acceptance

Tests cover scoped read/write/list/metadata, traversal, symlink escape, missing paths, denied operations, and platform path behavior. Bridge integration tests verify payload and error serialization.
