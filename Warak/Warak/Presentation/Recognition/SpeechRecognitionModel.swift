//
//  RecordNoteViewModel.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import Combine

@Observable
class SpeechRecognitionModel {
    private(set) var isRecording = false
    private(set) var recognizedText = ""
    private var cancellables: Set<AnyCancellable> = []
    var recognizingLanguage = Languages.ko_KR
    let supportedLanguages = Languages.allCases
    
    let recognizer = SpeechRecognizer()
    
    init() {
        bind()
    }
    
    private func bind() {
        recognizer.recognizedTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] (text, isFinal) in
                if !text.isEmpty {
                    self?.recognizedText = text
                }
                
                if isFinal {
                    Task { @MainActor in // isFinal 방출 시점에는 오디오 세션 정리 전이므로, 다음 태스크로 스케쥴링
                        self?.isRecording = false
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func startRecording() {
        isRecording = true
        recognizer.startRecording(languageCode: recognizingLanguage.rawValue)
    }
    
    func stopRecording() {
        isRecording = false
        recognizer.stopRecording()
    }
}

extension SpeechRecognitionModel {
    func triggerButtonTapped() {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
}

enum Languages: String, CaseIterable {
    case ko_KR
    case en_US
    
    var displayName: String {
        switch self {
        case .ko_KR:
            return "한국어"
        case .en_US:
            return "영어"
        }
    }
}
