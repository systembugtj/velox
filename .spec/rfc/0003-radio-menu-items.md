# RFC 0003: Radio Menu Items

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add mutually exclusive radio menu items to the existing Swift menu plugin API.

## Problem

The menu plugin currently supports normal, check, icon, predefined, separator, and submenu items, but has no radio item representation.

## Goals

Allow applications to define radio groups whose selection is reflected in native menu state and menu events.

## Non-goals

General menu redesign, keyboard shortcut APIs, and cross-process menu state are out of scope.

## Design

Add a radio case to the menu item model and decode path in `Sources/VeloxPluginMenu/MenuPlugin.swift`. Define group identity and selection in the serialized command payload; construct native radio items with one selected member per group. Preserve decoding of existing menu kinds and define deterministic behavior for missing or duplicate selections.

## Acceptance

Tests cover decoding, empty and populated groups, selection changes, invalid group input, and existing menu kinds. macOS integration test confirms native menu state and emitted selection event.
