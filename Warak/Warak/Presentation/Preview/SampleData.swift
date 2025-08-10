//
//  SampleData.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import SwiftUI
import SwiftData

/// ref: https://developer.apple.com/documentation/coredata/adopting-swiftdata-for-a-core-data-app
struct SampleData: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content.modelContainer(context)
    }
    
    static func makeSharedContext() throws -> ModelContainer {
        let schema = Schema([Note.self])
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: schema, configurations: config)
        createSampleData(into: container.mainContext)
        return container
    }
}

extension SampleData {
    static func createSampleData(into modelContext: ModelContext) {
        Task { @MainActor in
            Note.debugData.forEach {
                modelContext.insert($0)
            }
            
            do {
                try modelContext.save()
            } catch {
                print("❌ 프리뷰용 데이터 저장에 실패했습니다.")
            }
        }
    }
}

@available(iOS 18.0, *)
extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var sampleData: Self = .modifier(SampleData())
}
