# RFC 0017: Deep Link Plugin

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add a plugin that receives application deep links and delivers validated URLs to the app runtime.

## Problem

Velox has no built-in deep-link plugin, so applications lack a common event path for OS-delivered URLs.

## Goals

Define URL scheme registration expectations, startup URL delivery, runtime events, and validation rules.

## Non-goals

Universal link domain hosting, OAuth session management, and automatic URL routing are out of scope.

## Design

Create `VeloxPluginDeepLink` using existing plugin lifecycle/event APIs. Parse configured allowed schemes and deliver initial and subsequent URLs through a typed event. Add only the platform hooks supported by current app lifecycle; clearly document required project metadata and avoid modifying generated projects implicitly. Reject malformed or disallowed schemes.

## Acceptance

Tests cover parsing, scheme allowlist, malformed input, initial launch URL, repeated delivery, and event serialization. Platform integration tests validate OS callback wiring for each supported target.
