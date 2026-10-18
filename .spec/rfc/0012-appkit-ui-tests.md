# RFC 0012: AppKit UI Test Validation

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Run the existing UI-enabled Velox runtime test suite on an AppKit-capable macOS host and record reproducible results.

## Problem

`EventLoopIntegrationTests.swift` gates UI tests behind `VELOX_ENABLE_UI_TESTS=1`; those tests have not been run in the current verification record.

## Goals

Establish a passing or actionable test result for the existing AppKit integration tests without changing product behavior.

## Non-goals

Adding UI tests for unrelated RFC features or changing CI infrastructure is out of scope.

## Design

Use the existing Swift Package test target and the documented `VELOX_ENABLE_UI_TESTS=1` gate on macOS with AppKit available. First inspect package test commands and environment requirements; do not introduce a shell wrapper. Record OS, Swift version, command, result, and any reproducible failure. Fixes discovered belong in the corresponding feature RFC.

## Acceptance

All gated UI tests execute and pass, or this RFC records a concrete failure with linked follow-up RFC and reproducible diagnostics. Confirm the non-UI test suite remains runnable with the gate unset.
