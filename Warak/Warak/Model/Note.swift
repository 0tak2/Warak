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
        .init(
            id: UUID(uuidString: "22e8d807-d518-4b42-82d8-26c24b3a06c6")!,
            title: "아침 명상 기록",
            content: "햇살이 부드럽게 비치는 창가에서 10분간 호흡 명상을 했다. 마음이 한결 차분해졌다.",
            tags: ["명상", "마음챙김", "아침 루틴"],
            createdAt: Date(timeIntervalSinceNow: -86400 * 3),
            updatedAt: Date(timeIntervalSinceNow: -86400 * 3 + 3600)
        ),
        .init(
            id: UUID(uuidString: "e4c7b0c1-7484-4c7f-8d2f-6a71b5aafc27")!,
            title: "커피 테이스팅 노트",
            content: "에티오피아 예가체프를 드립으로 내려 마셨다. 시트러스와 꽃향이 인상적이었다.",
            tags: ["커피", "취미", "테이스팅"],
            createdAt: Date(timeIntervalSinceNow: -86400 * 2),
            updatedAt: Date(timeIntervalSinceNow: -86400 * 2 + 7200)
        ),
        .init(
            id: UUID(uuidString: "a8929c8d-0f0d-4e15-b6e0-d92a1e88b8f3")!,
            title: "산책 중 발견한 골목길",
            content: "작은 서점과 카페가 나란히 있는 조용한 골목을 발견했다. 주말에 다시 와야겠다.",
            tags: ["산책", "발견", "사진스팟"],
            createdAt: Date(timeIntervalSinceNow: -86400),
            updatedAt: Date(timeIntervalSinceNow: -86400 + 5400)
        ),
        .init(
            id: UUID(uuidString: "9b2c60a9-878e-4a3d-9b40-14eaf395fbd8")!,
            title: "개발 아이디어 스케치",
            content: "아이들이 AR로 동물과 교감할 수 있는 학습 앱을 구상했다. 자연 보호 교육과 연결 가능.",
            tags: ["개발", "AR", "아이디어"],
            createdAt: Date(timeIntervalSinceNow: -43200),
            updatedAt: Date(timeIntervalSinceNow: -43200 + 1800)
        ),
        .init(
            id: UUID(uuidString: "daacf157-2d72-421c-a886-ea2d50f86e87")!,
            title: "저녁 요리 메모",
            content: "토마토 파스타를 만들었는데 마늘과 올리브 오일 비율이 완벽했다. 다음엔 바질을 더 넣어야지.",
            tags: ["요리", "레시피", "저녁"],
            createdAt: Date(timeIntervalSinceNow: -21600),
            updatedAt: Date(timeIntervalSinceNow: -21600 + 900)
        ),
        .init(
            id: UUID(uuidString: "c3c55d5c-4826-412a-8391-5cfec87ed067")!,
            title: "독서 노트",
            content: "『작은 습관의 힘』 3장을 읽었다. 습관 형성의 핵심은 '쉽게 시작하는 것'임을 다시 느꼈다.",
            tags: ["독서", "습관", "자기계발"],
            createdAt: Date(timeIntervalSinceNow: -3600),
            updatedAt: Date()
        )
    ]
#endif
}
