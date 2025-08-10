//
//  GeminiEndpoints.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation

struct GeminiEndpoints {
    private let baseURL = URL(string: "https://generativelanguage.googleapis.com/v1beta/models")!
    
    func requestPrediction(inputText: String) async throws -> ResponsePredictionDTO {
        let endpoint = HTTPEndpoint<RequestPredictionDTO, ResponsePredictionDTO>(
            destination: "\(baseURL)/gemini-2.0-flash-lite:generateContent",
            headers: [
                "X-goog-api-key": AppStaticProperties.shared.geminiApiKey
            ],
            body: RequestPredictionDTO(inputText: inputText),
            method: .post
        )
        
        return try await endpoint.send()
    }
}
