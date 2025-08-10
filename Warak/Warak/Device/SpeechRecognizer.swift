//
//  SpeechRecognizer.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import AVFoundation
import Speech
import Combine
import os.log

class SpeechRecognizer: NSObject {
    // MARK: Properties
    private let speechRecognizer = SFSpeechRecognizer()!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let logger = Logger.category("SpeechRecognizer")
    
    /// 인식된 텍스트를 퍼블리시한다. (인식된 텍스트, 완료 여부)
    let recognizedTextSubject: PassthroughSubject<(String, Bool), Never> = .init()
    
    /// 발생한 오류를 퍼블리시한다.
    let errorSubject: PassthroughSubject<SpeechRecognizerError, Never> = .init()
    
    override init() {
        super.init()
        speechRecognizer.delegate = self
    }
    
    var isAuthorized: Bool {
        SFSpeechRecognizer.authorizationStatus() == .authorized
    }
    
    func startRecording() {
        // 이전 음성인식 태스크가 있다면 취소
        if let recognitionTask = recognitionTask {
            recognitionTask.cancel()
            self.recognitionTask = nil
        }
        
        // 오디오 세션 초기화
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            logger.error("error setting audio session: \(error)")
            errorSubject.send(.failedToSetAudioSession)
        }
        let inputNode = audioEngine.inputNode

        // 음성인식 요청 초기화
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to created a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // 음성인식 태스크 시작
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                self?.recognizedTextSubject.send((
                    result.bestTranscription.formattedString,
                    isFinal
                ))
            }
            
            if error != nil {
                isFinal = true
                self?.errorSubject.send(.failedToRecognizeSpeech)
                Logger.category("SpeechRecognizer").error("error recognizing speech: \(error)")
            }
            
            // 완료 후 처리
            if isFinal {
                self?.cleanup(inputNode: inputNode)
            }
        }

        // 마이크 입력 설정
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            logger.error("error starting audio session: \(error)")
            errorSubject.send(.failedToRecognizeSpeech)
        }
    }
    
    func stopRecording() {
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
        cleanup()
    }
    
    private func deactivateSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            logger.error("failed to deactivate session: \(error.localizedDescription)")
        }
    }

    private func cleanup(inputNode: AVAudioInputNode? = nil) {
        if let node = inputNode {
            node.removeTap(onBus: 0)
        } else {
            audioEngine.inputNode.removeTap(onBus: 0)
        }
        recognitionRequest = nil
        recognitionTask = nil
        audioEngine.stop()
        audioEngine.reset()
        deactivateSession()
    }
}

extension SpeechRecognizer {
    /// STT 권한을 요청한다. SpeechRecognizer 인스턴스의 라이프사이클과 상관 없는 타입 메서드이다. 즉, 인스턴스화 전인 앱 실행 직후에 실행해도 된다.
    static func requestAuthorization(complete: ((RequestAuthorizationResult) -> Void)?) {
        let logger = Logger.category("SpeechRecognizer")

        SFSpeechRecognizer.requestAuthorization { authStatus in
            switch authStatus {
            case .authorized:
                logger.info("Speech authorized")
                complete?(.authorized)
            case .denied:
                logger.warning("Speech authorization denied")
                complete?(.notAuthorized("Speech 권한이 거부되었습니다."))
            case .restricted:
                logger.warning("Speech authorization denied")
                complete?(.notAuthorized("Speech 권한이 제한되었습니다."))
            case .notDetermined:
                logger.warning("Speech authorization denied")
                complete?(.notAuthorized("아직 Speech 권한을 허용받지 못했습니다."))
            default:
                logger.warning("기대하지 않은 authState입니다. \(String(describing: authStatus))")
                complete?(.notAuthorized("기대하지 않은 authState입니다. \(String(describing: authStatus))"))
            }
        }
    }
}

extension SpeechRecognizer: SFSpeechRecognizerDelegate {
    // MARK: SFSpeechRecognizerDelegate
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if !available {
            logger.warning("SpeechRecognizer is unavailable")
        }
    }
}

enum SpeechRecognizerError: LocalizedError {
    case failedToSetAudioSession
    case failedToStartAudioEngine
    case failedToRecognizeSpeech
    case internalError(String)
    
    var errorDescription: String? {
        switch self {
        case .failedToSetAudioSession:
            return "AudioSession을 설정하는 데 실패했습니다."
        case .failedToStartAudioEngine:
            return "AudioEngine을 시작하는 데 실패했습니다."
        case .failedToRecognizeSpeech:
            return "음성 인식 중 오류가 발행했습니다."
        case .internalError(let message):
            return "내부 에러입니다. \(message)"
        }
    }
}
