# RFC 0004: Plugin-Defined Permissions

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Let plugins declare permission identifiers and command requirements through the Velox plugin protocol.

## Problem

Permission configuration exists in the runtime, but `VeloxPlugin` has no declaration contract to connect plugin commands to permission identifiers.

## Goals

Make each plugin's permission requirements discoverable and enforceable by the existing command authorization path.

## Non-goals

Platform-specific restrictions are handled by RFC 0005. This RFC does not add new built-in plugins or silently grant permissions.

## Design

Add a defaulted permission declaration property or requirement to `VeloxPlugin` in `Sources/VeloxRuntime/Plugin.swift`. During plugin setup, register declarations with the permission registry and associate declared commands with identifiers. Keep existing conformers source-compatible through a protocol-extension default returning no declarations. Unknown or undeclared permissions must fail closed with a diagnostic.

## Acceptance

Tests verify legacy plugins still compile, declared commands register, allowed calls succeed, denied calls fail, and duplicate/unknown identifiers produce deterministic errors.
