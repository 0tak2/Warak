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
    var id: UUID
    var title: String?
    var content: String
    var tags: [String] = []
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        title: String? = nil,
        content: String,
        tags: [String] = [],
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.content = content
        self.tags = tags
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
#if DEBUG
    static var debugData: [Note] = [
        .init(id: UUID(uuidString: "22e8d807-d518-4b42-82d8-26c24b3a06c6")!, content: "테스트 1"),
        .init(id: UUID(uuidString: "daacf157-2d72-421c-a886-ea2d50f86e87")!, content: "테스트 2"),
        .init(id: UUID(uuidString: "c3c55d5c-4826-412a-8391-5cfec87ed067")!, content: "테스트 3"),
    ]
#endif
}
