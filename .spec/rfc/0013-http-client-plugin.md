# RFC 0013: HTTP Client Plugin

**Status:** Draft

**Parent:** [0001](0001-verified-gaps.md)

## Summary

Add an opt-in built-in HTTP client plugin with a permission-checked command API for webview callers.

## Problem

Velox has no built-in HTTP client plugin, leaving apps without a shared runtime API for network requests.

## Goals

Provide bounded request/response operations through the plugin command and event bridge, governed by declared permissions.

## Non-goals

Proxy configuration, credential storage, cookie synchronization, and automatic retries are out of scope.

## Design

Create a `VeloxPluginHTTP` Swift package target following existing plugin target structure and re-export it from `Sources/VeloxPlugins/VeloxPlugins.swift`. Use `URLSession` with explicit timeout, response-size limits, cancellation, and structured errors. Expose only required methods and enforce host/URL scopes through RFC 0004 permission declarations. Preserve platform availability through conditional compilation where needed.

## Acceptance

Swift tests cover success, HTTP errors, timeout, cancellation, size limit, malformed URL, and denied host scope. Plugin integration test verifies JS invocation and response serialization on supported platforms.
