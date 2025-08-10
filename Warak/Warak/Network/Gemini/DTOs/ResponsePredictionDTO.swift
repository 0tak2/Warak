//
//  ResponsePredictionDTO.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation

struct ResponseDTO: Codable {
    let title: String
    let tags: [String]
}

struct ResponsePredictionDTO: Decodable {
    let candidates: [Candidate]
    let usageMetadata: UsageMetadata?
    let modelVersion: String?
    let responseId: String?

    struct Candidate: Decodable {
        let content: Content
        let finishReason: String
        let avgLogprobs: Double?
    }

    struct Content: Decodable {
        let parts: [Part]
        let role: String?
    }

    struct Part: Decodable {
        let text: String
    }

    struct UsageMetadata: Decodable {
        let promptTokenCount: Int?
        let candidatesTokenCount: Int?
        let totalTokenCount: Int?
        let promptTokensDetails: [TokensDetails]?
        let candidatesTokensDetails: [TokensDetails]?
    }

    struct TokensDetails: Decodable {
        let modality: String?
        let tokenCount: Int?
    }
    
    /// 첫 후보의 첫 파트 텍스트를 JSON으로 보고 ResponseDTO로 디코드
    func decodePrediction() throws -> ResponseDTO {
        guard let candidate = candidates.first else { throw GeminiParseError.noCandidates }
        guard let part = candidate.content.parts.first else { throw GeminiParseError.noParts }
        guard !part.text.isEmpty else { throw GeminiParseError.noTextPayload }

        let text = part.text
        
        // text 자체가 JSON 문자열이므로 그대로 디코드
        guard let data = text.data(using: .utf8) else {
            throw GeminiParseError.invalidEmbeddedJSON(text)
        }
        
        do {
            return try JSONDecoder().decode(ResponseDTO.self, from: data)
        } catch {
            // 일부 모델이 앞뒤에 ```json … ``` 래핑하는 경우 대비 스트립
            let stripped = text
                .replacingOccurrences(of: "```json", with: "")
                .replacingOccurrences(of: "```", with: "")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            guard let postProcessedData = stripped.data(using: .utf8),
                  let dto = try? JSONDecoder().decode(ResponseDTO.self, from: postProcessedData) else {
                throw GeminiParseError.decodeError(error, String(data: data, encoding: .utf8) ?? "no data")
            }
            return dto
        }
    }
}

enum GeminiParseError: Error {
    case noCandidates
    case noParts
    case noTextPayload
    case invalidEmbeddedJSON(String) // 원문 저장
    case decodeError(Error, String) // 원인 에러, 원문
}
