# RFC 0010: Version from External File

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Allow the application version to come from a project-relative file instead of only an inline config value.

## Problem

Configuration currently supports only a root version field, forcing version duplication when package managers or release tooling already own the version.

## Goals

Resolve a configured version-file path during config loading and use its validated value for bundle metadata.

## Non-goals

Main executable naming is specified in RFC 0009. Automatic version-control or network lookups are out of scope.

## Design

Add an optional version source path to the root config model in `Sources/VeloxRuntime/Config.swift`, with a documented precedence rule between inline and file values. Read relative to the config directory, trim surrounding whitespace, validate a supported version string, and fail with the source path in the error. Preserve inline version behavior when no file source is configured.

## Acceptance

Tests cover inline fallback, file value, whitespace, missing file, empty content, invalid version, and conflicting sources. Bundle metadata fixture confirms resolved value.
