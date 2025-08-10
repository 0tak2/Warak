//
//  Note.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import SwiftData

@Model
final class Note {
    var title: String?
    var content: String
    var tags: [String] = []
    var createdAt: Date
    var updatedAt: Date
    
    init(
        title: String? = nil,
        content: String,
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.title = title
        self.content = content
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
