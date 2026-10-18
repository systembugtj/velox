# RFC 0023: Android Project Generation and Workflow

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Define an Android-specific project-generation and development workflow for applications using Velox APIs.

## Problem

The CLI has no Android project generation or development command, so Velox cannot create or run Android application projects.

## Goals

Specify the supported Android runtime, generated project structure, build/run commands, and bridge behavior.

## Non-goals

 iOS support, Play Store publishing, and assuming Swift runtime modules execute directly on Android are out of scope.

## Design

Define an Android-native implementation boundary first: retain shared API/config semantics, but implement Android runtime pieces in a supported native language and bridge them to the existing frontend contract. Add a separate Android template and explicit CLI commands under `Sources/VeloxCLI`; do not force Android code into Swift targets that cannot compile there. Generate a Gradle project with pinned toolchain versions and deterministic files.

## Acceptance

Generate a fixture project, build it with Gradle, launch on an emulator, and verify the supported bridge calls. Tests check generated files and clear diagnostics for missing Android SDK/tooling. Confirm Swift package desktop builds remain unchanged.
