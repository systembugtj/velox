# RFC 0005: Platform-Specific Capability Restrictions

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow capability and permission configuration to restrict access by runtime platform.

## Problem

`CapabilityConfig` targets windows and webviews but cannot express platform availability, leaving one shared configuration unable to narrow permissions for a specific OS.

## Goals

Add optional platform selectors and enforce them before command authorization.

## Non-goals

Per-plugin permission declarations are covered by RFC 0004. This RFC does not add platform backends.

## Design

Extend `CapabilityConfig` in `Sources/VeloxRuntime/Permission.swift` with an optional list of supported platform identifiers. Resolve the current platform once in the permission evaluator and reject capabilities that exclude it. Omitted selectors preserve current behavior. Validate unknown identifiers during configuration loading.

## Acceptance

Codable tests cover omitted, known, and unknown platform names. Permission tests prove allowed platforms retain existing behavior and excluded platforms deny access before command execution. Run platform-specific builds for each supported identifier.
