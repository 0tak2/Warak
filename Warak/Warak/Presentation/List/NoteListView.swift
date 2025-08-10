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
                NavigationLink {
                    Text("Item at \(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))")
                } label: {
                    Text(item.createdAt, format: Date.FormatStyle(date: .numeric, time: .standard))
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
}

#Preview {
    func setTestData(modelContainer: ModelContainer) {
        Task { @MainActor in
            modelContainer.mainContext.insert(Note(content: "테스트 1"))
            modelContainer.mainContext.insert(Note(content: "테스트 2"))
            modelContainer.mainContext.insert(Note(content: "테스트 3"))
        }
    }
    
    let modelContainer = try! ModelContainer(for: Note.self, configurations: .init(isStoredInMemoryOnly: true))
    
    setTestData(modelContainer: modelContainer)
    
    return ContentView()
        .modelContainer(modelContainer)
}
