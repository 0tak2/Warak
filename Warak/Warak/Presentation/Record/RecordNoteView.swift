//
//  RecordNoteView.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import SwiftUI

struct RecordNoteView: View {
    @State private var viewModel = RecordNoteViewModel()
    @State private var animationTimer: Timer?
    @State private var buttonPadding: CGFloat = 64
    @State private var direction: AnimationDirection = .decrease
    @State private var recognizedText: String = ""
    private let maxPadding: CGFloat = 128
    private let minPadding: CGFloat = 16
    private let animationAlpha: CGFloat = 4
    
    var body: some View {
        VStack {
            if viewModel.isRecording {
                Text(viewModel.recognizedText)
            }
            
            Button {
                recordButtonTapped()
            } label: {
                Circle()
                    .foregroundStyle(Color.red)
            }
            .padding(.all, buttonPadding)
        }
    }
}

extension RecordNoteView {
    func recordButtonTapped() {
        if !viewModel.isRecording {
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                withAnimation {
                    if buttonPadding <= minPadding {
                        direction = .increase
                    }
                    
                    if buttonPadding >= maxPadding {
                        direction = .decrease
                    }
                    
                    buttonPadding += direction.delta * animationAlpha
                }
            }
        } else {
            self.animationTimer?.invalidate()
            self.animationTimer = nil
        }
        
        viewModel.circleButtonTapped()
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
    RecordNoteView()
}
