# Thaw URI Schemes & Deep Linking

Thaw supports custom URL schemes for deep linking, enabling integration with automation tools like Raycast, Alfred, and custom scripts.

## Overview

Thaw registers the `thaw://` URL scheme in `Info.plist` via `CFBundleURLTypes`. This allows external applications and scripts to trigger Thaw actions programmatically.

## thaw:// URL Scheme

### Supported Actions

| URL | Action | Description |
|-----|--------|-------------|
| `thaw://toggle-hidden` | Toggle Hidden Section | Shows/hides the hidden menu bar section |
| `thaw://toggle-always-hidden` | Toggle Always-Hidden | Shows/hides the always-hidden section |
| `thaw://search` | Open Search Panel | Displays the menu bar item search panel |
| `thaw://toggle-thawbar` | Toggle Thaw Bar | Toggles the IceBar on the active display |
| `thaw://toggle-application-menus` | Toggle App Menus | Shows/hides application menus |
| `thaw://open-settings` | Open Settings | Opens the Thaw settings window |

### Usage Examples

#### Terminal
```bash
open "thaw://toggle-hidden"
open "thaw://search"
open "thaw://open-settings"
```

#### Swift
```swift
NSWorkspace.shared.open(URL(string: "thaw://search")!)
```

#### AppleScript
```applescript
tell application "System Events"
    open location "thaw://toggle-hidden"
end tell
```

#### Bash Script
```bash
#!/bin/bash
# Toggle hidden section
open "thaw://toggle-hidden"
```

### Raycast Integration

#### Quicklink (Simple URL Trigger)
1. Open Raycast → Create Quicklink
2. Name: `Toggle Hidden Section`
3. Link: `thaw://toggle-hidden`
4. Assign a hotkey (e.g., `⌃⌥⌘H`)

#### Script Command (With Arguments)
```bash
#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Thaw Actions
# @raycast.mode silent
# @raycast.argument1 { "type": "dropdown", "placeholder": "Action", "data": [{"title": "Toggle Hidden", "value": "toggle-hidden"}, {"title": "Search", "value": "search"}, {"title": "Settings", "value": "open-settings"}] }

open "thaw://${1}"
```

### Alfred Workflow

#### URL Trigger
1. Create a new Workflow
2. Add `Open URL` object
3. URL: `thaw://toggle-hidden`
4. Connect to a hotkey trigger

#### Script Filter (Advanced)
```bash
# Keyword: thaw
# Action: Toggle hidden section
open "thaw://toggle-hidden"
```

## Info.plist URLs

The following URLs are configured in `Thaw/Resources/Info.plist` for internal use:

| Key | Value | Description |
|-----|-------|-------------|
| `ThawRepositoryURL` | `https://github.com/stonerl/Thaw` | GitHub repository |
| `ThawDonateURL` | `https://github.com/sponsors/stonerl` | Sponsorship page |
| `ThawMenuBarItemSpacingExecutableURI` | `file:///usr/bin/env` | Executable path for spacing commands |

## System URLs

Thaw uses the following system URLs to open macOS Settings:

| URL | Opens |
|-----|-------|
| `x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture` | Screen Recording settings |

## Notes

- All `thaw://` URLs work even when Thaw is not currently in the foreground
- The app may activate itself depending on the action
- URL handling is case-insensitive for the host portion
- Invalid URLs are logged but silently ignored
