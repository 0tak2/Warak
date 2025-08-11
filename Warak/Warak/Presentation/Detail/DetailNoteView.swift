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
    
    private struct Constants {
        static let largeSpacerHeight: CGFloat = 32
        static let mediumSpacerHeight: CGFloat = 16
        static let smallSpacerHeight: CGFloat = 4
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(note?.title ?? "...")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: Constants.largeSpacerHeight)
                
                Text(note?.content ?? "...")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: Constants.mediumSpacerHeight)
                
                HStack {
                    ForEach(note?.tags ?? [], id: \.self) { tag in
                        Text(tag)
                            .font(.footnote)
                    }
                    
                    Spacer()
                }
                
                Spacer()
                    .frame(height: Constants.mediumSpacerHeight)
                
                Text("\((note?.createdAt ?? Date()).localizedDescription) 작성")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                    .frame(height: Constants.smallSpacerHeight)
                
                Text("\((note?.updatedAt ?? Date()).localizedDescription) 수정")
                    .font(.footnote)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .alert("노트를 찾지 못했습니다", isPresented: $showingErrorAlert) {
            Button("확인") { }
        }
    }
}

#Preview(traits: .sampleData) {
    return DetailNoteView(noteID: UUID(uuidString: "22e8d807-d518-4b42-82d8-26c24b3a06c6")!)
}
