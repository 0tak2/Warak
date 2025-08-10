//
//  SpeechRecognizer.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import AVFoundation
import Speech
import os.log

class SpeechRecognizer {
    // MARK: Properties
    private let speechRecognizer = SFSpeechRecognizer()!
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    private let logger = Logger.category("SpeechRecognizer")
    
    var isAuthorized: Bool {
        SFSpeechRecognizer.authorizationStatus() == .authorized
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
