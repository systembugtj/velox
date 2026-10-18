# RFC 0001: Verified Velox Gaps (Umbrella)

**Status:** Draft

**Type:** Umbrella

## Summary

This umbrella tracks the confirmed gaps recorded in the former root `TODO.md`. Each feature or platform gap has one child RFC. Child RFCs define the Swift-side design and acceptance checks; this document only coordinates their completion.

## Problem

The gap list spans configuration, runtime APIs, plugins, bundling, and platform workflows. Treating it as one change would mix unrelated public interfaces and release risks.

## Goals

Every child RFC has an agreed scope, is implemented and validated, or is explicitly rejected or superseded. The former TODO list is removed only after its entries are represented by these RFCs.

## Non-goals

This umbrella does not approve or implement child RFCs. Future gaps discovered after this set is closed require new RFCs or a new umbrella.

## Children

| RFC | Concern |
|-----|---------|
| [0023](0023-android-project-workflow.md) | Android Project Generation and Workflow |
| [0022](0022-ios-project-workflow.md) | iOS Project Generation and Workflow |
| [0021](0021-windows-bundling.md) | Windows Bundling Targets |
| [0020](0020-linux-bundling.md) | Linux Bundling Targets |
| [0019](0019-file-associations.md) | Bundle File Associations |
| [0018](0018-external-binaries.md) | External Bundle Binaries |
| [0017](0017-deep-link-plugin.md) | Deep Link Plugin |
| [0016](0016-global-shortcut-plugin.md) | Global Shortcut Plugin |
| [0015](0015-updater-plugin.md) | Updater Plugin |
| [0014](0014-filesystem-plugin.md) | File System Plugin |
| [0013](0013-http-client-plugin.md) | HTTP Client Plugin |
| [0012](0012-appkit-ui-tests.md) | AppKit UI Test Validation |
| [0011](0011-schema-validation.md) | Configuration Schema Validation |
| [0010](0010-external-version-file.md) | Version from External File |
| [0009](0009-main-binary-name-override.md) | Main Binary Name Override |
| [0008](0008-json5-toml-config.md) | JSON5 and TOML Configuration |
| [0007](0007-bundle-metadata.md) | Bundle Metadata Fields |
| [0006](0006-resource-glob-patterns.md) | Glob Patterns for Bundle Resources |
| [0005](0005-platform-capability-restrictions.md) | Platform-Specific Capability Restrictions |
| [0004](0004-plugin-permissions.md) | Plugin-Defined Permissions |
| [0003](0003-radio-menu-items.md) | Radio Menu Items |
| [0002](0002-tray-icon-images.md) | Tray Icon Image Support |

## Acceptance

Close only after all children reach a terminal status and their task tracking is synchronized. The AppKit test child closes when the enabled UI suite has a recorded result on an AppKit-capable host; it does not introduce a new product feature.
