# RFC 0008: JSON5 and TOML Configuration

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow Velox configuration files in JSON5 and TOML formats alongside existing JSON.

## Problem

The runtime currently decodes configuration with `JSONDecoder`, limiting comments, trailing commas, and TOML-based project configuration.

## Goals

Select a parser from the configuration file extension and decode all supported formats into the same `VeloxConfig` model.

## Non-goals

Schema validation and changing the default config format are out of scope.

## Design

Introduce a format-dispatch layer at the existing config-loading boundary in `Sources/VeloxRuntime/Config.swift`. Keep Codable model semantics shared; use maintained parsers with pinned package versions only after dependency approval, or implement a constrained parser only if package policy forbids dependencies. Preserve JSON loading and produce file/line-aware parse errors where parser exposes locations.

## Acceptance

Fixtures decode equivalent JSON, JSON5, and TOML configurations to equal `VeloxConfig` values. Tests cover malformed input, unsupported extension, and legacy JSON loading. Validate dependency license and platform availability before implementation.
