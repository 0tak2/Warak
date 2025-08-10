//
//  NoteListView.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import SwiftUI
import SwiftData

struct NoteListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Note]
    @Binding var navigationModel: NavigationModel

    var body: some View {
        List {
            ForEach(items) { item in
                Button(item.title ?? getPartialString(item.content)) {
                    navigationModel.push(.detail(item.id))
                }
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
            
            ToolbarItem {
                Button {
                    addItem()
                } label: {
                    Label("노트 추가", systemImage: "plus")
                }

            }
        }
    }
}

extension NoteListView {
    private func addItem() {
        navigationModel.push(.record)
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    
    private func getPartialString(_ original: String) -> String {
        let maxStringLength: Int = 10
        
        if original.count < maxStringLength {
            return original
        }
        
        return String(original[original.startIndex..<original.index(original.startIndex, offsetBy: 10)])
    }
}

#Preview(traits: .sampleData) {
    return ContentView()
}
