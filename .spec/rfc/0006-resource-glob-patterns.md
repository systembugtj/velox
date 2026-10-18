# RFC 0006: Glob Patterns for Bundle Resources

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Expand configured `bundle.resources` glob patterns into deterministic files during bundling.

## Problem

`copyBundleResources` in `Sources/VeloxBundler/Bundler.swift` treats every entry as a literal path, so directory selections cannot include matching resources.

## Goals

Allow explicit glob patterns while preserving literal path behavior and reporting unmatched patterns.

## Non-goals

External binaries, resource downloads, and platform-specific bundle layouts are out of scope.

## Design

Expand patterns in a pure helper before copying. Resolve matches relative to the config directory, sort normalized relative paths for reproducible output, reject traversal outside the project root unless explicitly supported by existing path policy, and preserve directory structure without collisions. Keep non-pattern entries on current literal-path handling. Do not add a new pattern dependency unless the package already provides one.

## Acceptance

Tests cover literal paths, matching and unmatched patterns, nested files, deterministic ordering, duplicate destinations, and traversal attempts. Bundle fixture confirms expected resource tree.
