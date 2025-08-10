//
//  RecordNoteView.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import SwiftUI
import os.log

struct RecordNoteView: View {
    @State private var speechRecognitionModel = SpeechRecognitionModel()
    @State private var animationTimer: Timer?
    @State private var direction: AnimationDirection = .decrease
    @State private var buttonPadding: CGFloat = 64
    @State private var showConfirmAlert = false
    
    @Binding var navigationModel: NavigationModel
    
    @Environment(\.modelContext) private var modelContext
    
    private let logger = Logger.category("RecordNoteView")
    
    private struct Constants {
        static let buttonInitialPadding: CGFloat = 128
        static let buttonMaxPadding: CGFloat = 128
        static let buttonMinPadding: CGFloat = 0
        static let buttonAnimationWeights: CGFloat = 4
    }
    
    var body: some View {
        VStack {
            if speechRecognitionModel.isRecording {
                Text(speechRecognitionModel.recognizedText)
            }
            
            if !speechRecognitionModel.isRecording {
                Picker("인식 언어", selection: $speechRecognitionModel.recognizingLanguage) {
                    ForEach(speechRecognitionModel.supportedLanguages, id: \.self) { language in
                        Text(language.displayName)
                    }
                }
                .pickerStyle(.menu)
            }
            
            Spacer()
            
            Button {
                recordButtonTapped()
                if !speechRecognitionModel.isRecording {
                    showConfirmAlert.toggle()
                }
            } label: {
                Circle()
                    .foregroundStyle(Color.red)
            }
            .padding(.all, buttonPadding)
            
            Spacer()
        }
        .alert("저장할까요?", isPresented: $showConfirmAlert) {
            Button("저장") {
                saveButtonTapped()
            }
            Button("다시 녹음하기") { }
        }
    }
}

// MARK: User Intents
extension RecordNoteView {
    func recordButtonTapped() {
        if !speechRecognitionModel.isRecording {
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                withAnimation {
                    if buttonPadding <= Constants.buttonMinPadding {
                        direction = .increase
                    }
                    
                    if buttonPadding >= Constants.buttonMaxPadding {
                        direction = .decrease
                    }
                    
                    buttonPadding += direction.delta * Constants.buttonAnimationWeights
                }
            }
        } else {
            self.animationTimer?.invalidate()
            self.animationTimer = nil
        }
        
        speechRecognitionModel.triggerButtonTapped()
    }
    
    func saveButtonTapped() {
        saveNote()
        navigationModel.pop()
    }
}

// MARK: Mutate Data
extension RecordNoteView {
    func saveNote() {
        Task {
            let aiPrediction = await getAiPrediction(text: speechRecognitionModel.recognizedText)
            
            await MainActor.run {
                let newNote = Note(
                    title: aiPrediction?.title,
                    content: speechRecognitionModel.recognizedText,
                    tags: aiPrediction?.tags ?? []
                )
                modelContext.insert(newNote)
            
                do {
                    try modelContext.save()
                } catch {
                    logger.error("failed to save note: \(error)")
                }
            }
        }
    }
    
    func getAiPrediction(text: String) async -> ResponseDTO? {
        let predictTask = Task {
            do {
                let endpoints = GeminiEndpoints() // TODO: should be injected from outside
                let prediction = try await endpoints.requestPrediction(inputText: text)
                return prediction
            } catch {
                logger.error("error getting prediction: \(error)")
                throw error
            }
        }

        let result = await predictTask.result

        do {
            let responseDTO = try result.get()
            return try responseDTO.decodePrediction()
        } catch {
            return nil
        }
    }
}

fileprivate enum AnimationDirection {
    case increase
    case decrease
    
    var delta: CGFloat {
        switch self {
        case .increase:
            return 1
        case .decrease:
            return -1
        }
    }
}

#Preview {
    RecordNoteView(navigationModel: .constant(NavigationModel()))
}
