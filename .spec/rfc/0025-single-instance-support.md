# RFC 0025: Framework-Level Single Instance Support

**Status:** Draft

**Depends on:** [RFC 0024](0024-global-runtime-configuration.md)

## Summary

Add opt-in single-instance startup handling to Velox. The first process acquires an OS-managed lock; later launches notify the primary process and exit before creating webviews or starting the application event loop.

## Problem

Velox currently allows multiple copies of one app to start. Duplicate event loops can collide over local resources, and each app must implement platform-specific locking and window activation itself.

## Goals

- Add an opt-in `app.singleInstance` configuration block with `enabled`, `wakeAction`, and optional `lockName`.
- Acquire the instance lock before configuration-dependent runtime setup, webview creation, or event-loop startup.
- On secondary launch, send a payload-free wake signal when requested, then exit successfully.
- Let the primary app activate its main window for `wakeAction: focus`; support `none` as silent exit.
- Release lock ownership automatically when process exits or crashes.
- Keep default behavior unchanged when single-instance mode is absent or disabled.

## Non-goals

- Forwarding command-line arguments, files, URLs, or arbitrary data from secondary instances.
- Cross-user or cross-session uniqueness unless explicitly configured later.
- Bringing every platform to feature parity in one change; unsupported platforms must fail clearly or report unsupported configuration.

## Design

Add Codable configuration types in `Sources/VeloxRuntime/Config.swift` and validate `wakeAction` and lock identifier during config loading. Missing configuration preserves current multi-instance behavior.

Introduce a small `VeloxLockManager` abstraction at the runtime startup boundary. Use OS kernel-owned locks: POSIX file locks on supported macOS/Linux targets and a named mutex on Windows. Keep lock files in a per-user runtime/cache location; derive a stable, sanitized lock key from app identifier unless `lockName` is supplied. Lock acquisition must distinguish primary ownership, an existing owner, and operational failure.

Integrate acquisition in `VeloxAppBuilder` before creating Wry/WebView resources. For a secondary process, deliver a payload-free wake event using a per-platform local IPC mechanism, then terminate with status 0 before starting the app runtime. The primary process observes the event and calls its existing window activation path only when `wakeAction` is `focus`.

Use the configuration directory conventions established by [RFC 0024](0024-global-runtime-configuration.md) only for stable per-user identity/paths; do not require the global preference store to be enabled. Keep OS locking and wake transport behind narrow protocols so Swift lifecycle code does not contain platform-specific branching.

## Acceptance

- Config tests cover defaults, valid actions, invalid actions, and lock-name validation.
- Lock tests prove one primary owner, secondary detection, release after normal exit, and recovery after process termination.
- Integration tests prove secondary startup creates no webview/event loop, sends no payload, and exits successfully.
- macOS integration test verifies `focus` activates primary window and `none` does not.
- Linux and Windows support is tested on native CI hosts; unsupported targets return an actionable error.
- Disabled or omitted configuration preserves existing multi-instance startup behavior.
