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
    @State private var showNotAuthorizedAlert: Bool = false
    
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
        .alert("음성 인식 권한을 허용해주세요", isPresented: $showNotAuthorizedAlert, actions: {
            Button("확인") { }
            Button("설정 앱에서 권한 허락하기") {
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
        }, message: {
            Text("음성 인식 기능을 사용하려면 설정에서 권한을 허용해주세요. 빠른 영감 기록을 위해서는 음성 인식 기능이 필요해요.")
        })
        .onAppear {
            requestSTTAuthorization()
        }
    }
}

extension ContentView {
    func requestSTTAuthorization() {
        SpeechRecognizer.requestAuthorization { @MainActor result in
            if case .notAuthorized(_) = result {
                showNotAuthorizedAlert = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Note.self, inMemory: true)
}
