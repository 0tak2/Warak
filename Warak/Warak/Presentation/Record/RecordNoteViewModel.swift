//
//  RecordNoteViewModel.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import Combine

@Observable
class RecordNoteViewModel {
    private(set) var isRecording = false
    private(set) var recognizedText = ""
    private var cancellables: Set<AnyCancellable> = []
    
    let recognizer = SpeechRecognizer()
    
    init() {
        bind()
    }
    
    private func bind() {
        recognizer.recognizedTextSubject
            .receive(on: RunLoop.main)
            .sink { [weak self] (text, isFinal) in
                self?.recognizedText = text
                print("recognizedText: \(text)")
                
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
        recognizer.startRecording()
    }
    
    func stopRecording() {
        isRecording = false
        recognizer.stopRecording()
    }
}

extension RecordNoteViewModel {
    func circleButtonTapped() {
        if !isRecording {
            startRecording()
        } else {
            stopRecording()
        }
    }
}
