# RFC 0009: Main Binary Name Override

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow a bundle configuration to select the executable name independently of the package or application name.

## Problem

The bundle config currently derives the executable name, so projects with a differently named binary cannot describe it explicitly.

## Goals

Use an optional `mainBinaryName` for executable discovery and bundle metadata while retaining derived naming by default.

## Non-goals

Reading version from an external file is specified separately in RFC 0010.

## Design

Add optional `mainBinaryName` to the relevant config model in `Sources/VeloxRuntime/Config.swift`. Resolve it once in bundler input preparation, validate it as a safe basename, and use it consistently for executable lookup and platform metadata. Keep omitted values on the current derivation path.

## Acceptance

Tests cover default naming, explicit name resolution, missing executable diagnostics, and invalid path components. Bundle fixture confirms executable and metadata use the configured name.
