# RFC 0015: Updater Plugin

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add an opt-in plugin for checking, downloading, verifying, and applying signed Velox application updates.

## Problem

Velox currently has no updater plugin, so apps must build update discovery and installation independently.

## Goals

Define a secure update lifecycle with explicit source policy, signature verification, progress events, and restart handoff.

## Non-goals

Publishing infrastructure, update server hosting, and unsigned update installation are out of scope.

## Design

Create a separate `VeloxPluginUpdater` target following plugin conventions. Reuse platform-native installation mechanisms where available; verify signed manifests and artifacts before replacing files. Define manifest format, key rotation, rollback, staging location, and supported OS matrix before implementation. Do not fetch or install until the app explicitly invokes an authorized command.

## Acceptance

Tests reject unsigned, tampered, expired, and incompatible updates; verify successful staging, cancellation, progress, and restart signaling. Platform integration tests prove atomic/rollback behavior. Security review required before approval.
