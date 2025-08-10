//
//  Logger+.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import os.log

extension Logger {
    static func category(_ category: String) -> Logger {
        Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.youngtaek.Warak", category: category)
    }
}
