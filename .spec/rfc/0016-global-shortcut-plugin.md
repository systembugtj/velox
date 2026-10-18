# RFC 0016: Global Shortcut Plugin

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add a plugin for registering, unregistering, and receiving events from application-wide keyboard shortcuts.

## Problem

Velox has no global shortcut plugin, preventing apps from responding to shortcuts while their window is inactive.

## Goals

Provide a platform-aware registration API with conflict reporting and lifecycle cleanup.

## Non-goals

In-window menu shortcuts and shortcut preference UI are out of scope.

## Design

Add `VeloxPluginGlobalShortcut` as an individual plugin target, exported by `VeloxPlugins.swift`. Isolate OS registration behind a small Swift protocol with platform implementations. Track registrations by stable identifier, release them on plugin shutdown, and report conflicts rather than silently replacing another app's registration. Require an explicit permission declaration through RFC 0004.

## Acceptance

Unit tests cover registration state, duplicate identifiers, conflicts, unregister, and shutdown cleanup. Native integration tests validate key delivery on each supported OS and denied-permission behavior.
