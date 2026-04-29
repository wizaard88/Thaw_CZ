//
//  DisplayIceBarConfiguration.swift
//  Project: Thaw
//
//  Copyright (Ice) © 2023–2025 Jordan Baird
//  Copyright (Thaw) © 2026 Toni Förster
//  Licensed under the GNU GPLv3

import AppKit

/// Per-display configuration for the Thaw Bar.
struct DisplayIceBarConfiguration: Codable, Equatable {
    /// Whether the Thaw Bar is enabled on this display.
    let useIceBar: Bool

    /// The location where the Thaw Bar appears on this display.
    let iceBarLocation: IceBarLocation

    /// Whether to always show hidden menu bar items on this display.
    ///
    /// This setting is only applicable when ``useIceBar`` is `false`.
    let alwaysShowHiddenItems: Bool

    /// The layout mode for the Thaw Bar on this display.
    let iceBarLayout: IceBarLayout

    /// The maximum number of items per row when the Thaw Bar is in grid layout.
    ///
    /// Valid range is 2 through 10.
    let gridColumns: Int

    /// Default configuration (disabled, dynamic location, horizontal layout).
    static let defaultConfiguration = DisplayIceBarConfiguration(
        useIceBar: false,
        iceBarLocation: .dynamic,
        alwaysShowHiddenItems: false,
        iceBarLayout: .horizontal,
        gridColumns: 4
    )

    /// Returns a new configuration with the `useIceBar` flag replaced.
    func withUseIceBar(_ value: Bool) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: value,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns
        )
    }

    /// Returns a new configuration with the `iceBarLocation` replaced.
    func withIceBarLocation(_ value: IceBarLocation) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: value,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns
        )
    }

    /// Returns a new configuration with the `alwaysShowHiddenItems` flag replaced.
    func withAlwaysShowHiddenItems(_ value: Bool) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: value,
            iceBarLayout: iceBarLayout,
            gridColumns: gridColumns
        )
    }

    /// Returns a new configuration with the `iceBarLayout` replaced.
    func withIceBarLayout(_ value: IceBarLayout) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: value,
            gridColumns: gridColumns
        )
    }

    /// Returns a new configuration with the `gridColumns` replaced.
    ///
    /// Values are clamped to the range 2 through 10.
    func withGridColumns(_ value: Int) -> DisplayIceBarConfiguration {
        DisplayIceBarConfiguration(
            useIceBar: useIceBar,
            iceBarLocation: iceBarLocation,
            alwaysShowHiddenItems: alwaysShowHiddenItems,
            iceBarLayout: iceBarLayout,
            gridColumns: Swift.max(2, Swift.min(value, 10))
        )
    }

    /// Builds per-display configurations for all connected screens.
    @MainActor
    static func buildConfigurations(
        onlyOnNotched: Bool,
        location: IceBarLocation
    ) -> [String: DisplayIceBarConfiguration] {
        var configs = [String: DisplayIceBarConfiguration]()
        for screen in NSScreen.screens {
            guard let uuid = Bridging.getDisplayUUIDString(for: screen.displayID) else {
                continue
            }
            let enabled = onlyOnNotched ? screen.hasNotch : true
            configs[uuid] = DisplayIceBarConfiguration(
                useIceBar: enabled,
                iceBarLocation: location,
                alwaysShowHiddenItems: false,
                iceBarLayout: .horizontal,
                gridColumns: 4
            )
        }
        return configs
    }
}

// MARK: - Backward-compatible decoding

extension DisplayIceBarConfiguration {
    enum CodingKeys: String, CodingKey {
        case useIceBar
        case iceBarLocation
        case alwaysShowHiddenItems
        case iceBarLayout
        case gridColumns
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.useIceBar = try container.decode(Bool.self, forKey: .useIceBar)
        self.iceBarLocation = try container.decode(IceBarLocation.self, forKey: .iceBarLocation)
        self.alwaysShowHiddenItems = try container.decode(Bool.self, forKey: .alwaysShowHiddenItems)
        self.iceBarLayout = try container.decodeIfPresent(IceBarLayout.self, forKey: .iceBarLayout) ?? .horizontal
        let decodedGridColumns = try container.decodeIfPresent(Int.self, forKey: .gridColumns) ?? 4
        self.gridColumns = Swift.max(2, Swift.min(decodedGridColumns, 10))
    }
}
