//
//  DetailNoteView.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import SwiftUI
import SwiftData
import os.log

struct DetailNoteView: View {
    let noteID: UUID
    private let logger = Logger.category("DetailNoteView")
    
    @Environment(\.modelContext) private var modelContext
    
    @State private var showingErrorAlert: Bool = false
    
    private var note: Note? {
        let fetchDescriptor = FetchDescriptor(predicate: #Predicate<Note> { note in
            note.id == noteID
        })
        
        do {
            let result = try modelContext.fetch(fetchDescriptor).first
            if result == nil {
                logger.error("노트를 찾을 수 없습니다. \(noteID)")
                showingErrorAlert = true
            }
            return result
        } catch {
            logger.error("failed to fecth Note id: \(noteID)")
            return nil
        }
    }
    
    var body: some View {
        VStack {
            Text(note?.title ?? "...")
            Text(note?.content ?? "...")
        }
        .alert("노트를 찾지 못했습니다", isPresented: $showingErrorAlert) {
            Button("확인") { }
        }
    }
}

#Preview(traits: .sampleData) {
    return DetailNoteView(noteID: UUID(uuidString: "22e8d807-d518-4b42-0000-26c24b3a06c0")!)
}
