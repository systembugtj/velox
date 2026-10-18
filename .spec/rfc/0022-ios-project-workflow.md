# RFC 0022: iOS Project Generation and Workflow

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Define an iOS-specific project-generation and development workflow for applications using Velox APIs.

## Problem

The CLI exposes only desktop-oriented `dev`, `build`, `bundle`, and `init` commands and cannot generate or run an iOS app project.

## Goals

Specify supported iOS runtime architecture, generated project contents, build/run commands, and platform limitations.

## Non-goals

Android support, watchOS, App Store submission automation, and pretending desktop WebView/runtime APIs work unchanged on iOS are out of scope.

## Design

Before implementation, define which Velox runtime modules can compile for iOS and which APIs are unavailable. Add a separate iOS project template and explicit CLI subcommands under `Sources/VeloxCLI`; keep platform-specific lifecycle and WebKit integration behind iOS-targeted Swift sources. Generate an Xcode project using the project's chosen supported mechanism and expose deterministic build/run commands without changing desktop defaults.

## Acceptance

On macOS with Xcode, generate a project from a fixture, build for an iOS simulator, launch it, and exercise the supported bridge. Tests assert unsupported desktop APIs fail clearly and generated project can be regenerated without unrelated diffs.
