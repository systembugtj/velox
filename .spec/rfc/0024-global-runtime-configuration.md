# RFC 0024: Generic Global Configuration Support

**Status:** Draft

## Summary

Add framework-managed runtime preferences for Velox applications. Swift runtime APIs and permission-checked `veloxInvoke` commands read and write user configuration in platform-standard application support directories, separate from immutable application security settings.

## Problem

`velox.json` is bundled at build time. Applications currently implement their own persistence for preferences and runtime state, producing inconsistent file locations and bridge APIs. The original proposal also describes layered sources, but precedence and CLI/environment overrides need precise compatibility rules before implementation.

## Goals

- Provide a platform-standard global config location.
- Provide typed native get, set, and delete operations.
- Expose equivalent bridge commands to frontend applications.
- Restrict frontend writes to user-owned keys; never permit runtime permission or IPC-policy changes.
- Define deterministic precedence between defaults, static manifest, user config, environment, and CLI inputs.
- Preserve existing `velox.json` behavior when no runtime config is used.

## Non-goals

- Relational or transactional storage; use SQLite for that.
- Frontend modification of security, permissions, or IPC boundaries.
- Implicit network configuration, migrations across apps, or automatic window-state persistence without a separate explicit setting.

## Design

Resolve a per-application config directory using the OS application-support conventions and app identifier. Proposed defaults: macOS `~/Library/Application Support/<identifier>/config.json`, Linux `$XDG_CONFIG_HOME/<identifier>/config.json` (fallback `~/.config`), and Windows `%APPDATA%/<identifier>/config.json`. Final directory naming must be stable and tested across supported OSes.

Implement a Swift `VeloxConfigManager` owned by runtime/app state, not a process-global singleton. Use serialized access and atomic file replacement so concurrent callers cannot corrupt JSON. Decode typed values at API boundaries and return explicit errors for malformed files, invalid keys, and I/O failures.

Resolve values highest-priority first: CLI overrides, `VELOX_CFG_*` environment overrides, user config file, static `velox.json`, then framework defaults. Specify normalization and type conversion for CLI/environment keys before implementation; do not parse arbitrary flags from the host process without an explicit Velox namespace.

Register `velox_config_get`, `velox_config_set`, and `velox_config_delete` through existing command dispatch. The JS bridge may write only `user.*` keys. Native framework code may manage reserved namespaces. Validate keys and canonicalize any path-valued settings; never allow traversal or symlink escape from a declared storage scope.

Implementation phases: (1) Swift storage and merge model; (2) runtime command handlers; (3) typed JS wrappers; (4) optional window geometry persistence only after explicit config schema and lifecycle behavior are agreed. Existing config API and security policy remain unchanged by default.

## Acceptance

- Unit tests verify per-platform path selection, typed get/set/delete, precedence, malformed JSON handling, atomic writes, and concurrent access.
- Security tests prove bridge writes outside `user.*` are rejected and path traversal/symlink escapes fail.
- Bridge tests verify all three commands, serialization, and structured error propagation.
- Existing apps with no runtime config retain current `velox.json` behavior.
- Window geometry persistence is not enabled implicitly; if included, it has separate opt-in tests and documented defaults.
