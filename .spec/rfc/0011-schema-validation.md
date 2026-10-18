# RFC 0011: Configuration Schema Validation

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Validate configuration against its declared schema URL before Velox starts runtime or bundling work.

## Problem

The schema URL is stored but not validated, so invalid configuration may fail later with less useful errors.

## Goals

Provide deterministic schema validation errors at the configuration boundary and keep schema validation opt-in.

## Non-goals

Adding alternate config formats is covered by RFC 0008. Fetching arbitrary remote schemas at runtime is out of scope unless separately approved.

## Design

Define local-schema and URL policy first. Validate after decoding in the config loader under `Sources/VeloxRuntime/Config.swift`; use a bounded, reviewed JSON Schema implementation or a supported local schema subset. Do not fetch a network URL implicitly during startup. Return structured path/keyword diagnostics and preserve behavior when no schema is configured.

## Acceptance

Tests cover valid/invalid data, missing local schema, unsupported schema version, path-specific diagnostics, and no-schema compatibility. Dependency and schema-dialect support must be confirmed before implementation.
