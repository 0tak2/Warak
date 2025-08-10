//
//  ContentView.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var navigationModel = NavigationModel()
    
    var body: some View {
        NavigationStack(path: $navigationModel.paths) {
            NoteListView(navigationModel: $navigationModel)
                .navigationDestination(for: NavigationItem.self) { path in
                    switch path {
                    case .record:
                        RecordNoteView()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
