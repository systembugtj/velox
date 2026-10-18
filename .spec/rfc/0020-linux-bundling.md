# RFC 0020: Linux Bundling Targets

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add Linux application bundle targets for AppImage, Debian packages, and RPM packages.

## Problem

The current bundle target model supports only `app` and `dmg`, leaving Linux applications without native distribution artifacts.

## Goals

Define supported Linux targets, metadata mapping, artifact layout, and actionable host-tool requirements.

## Non-goals

Windows targets, cross-compilation, repository hosting, and package signing services are out of scope.

## Design

Extend target decoding in `Sources/VeloxRuntime/Config.swift` and implement an isolated Linux bundler backend rather than expanding macOS-specific code paths. Generate AppImage, `.deb`, and `.rpm` only when their required tools are available; report missing tools before partial output. Reuse shared metadata/resource staging and define architecture mapping and permissions. Keep existing macOS targets unchanged.

## Acceptance

Linux CI builds each target and inspects artifact contents, executable permissions, metadata, and install paths. Tests cover missing tools and unsupported architecture. macOS bundle tests remain passing.
