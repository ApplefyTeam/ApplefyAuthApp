//
//  DisplayTime.swift
//  ApplefyAuthApp
//
//  Created by Denys on 01.06.2023.
//

import Foundation

/// A simple value representing a moment in time, stored as the number of seconds since the epoch.
struct DisplayTime {
    let timeIntervalSince1970: TimeInterval

    init(date: Date) {
        timeIntervalSince1970 = date.timeIntervalSince1970
    }

    var date: Date {
        return Date(timeIntervalSince1970: timeIntervalSince1970)
    }
}

