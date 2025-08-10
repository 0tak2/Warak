//
//  RequestPredictionDTO.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation

struct RequestPredictionDTO: Codable {
    let contents: [Content]
    let generationConfig: GenerationConfig
    
    init(contents: [Content], generationConfig: GenerationConfig) {
        self.contents = contents
        self.generationConfig = generationConfig
    }
    
    init(inputText: String) {
        self.init(
            contents: [
                .init(parts: [.init(text: "Generate a title and tags based on the memo content.\n[Memo Content] \(inputText)")])
            ],
            generationConfig: .init(
                responseMimeType: "application/json",
                responseSchema: .init(
                    type: "OBJECT",
                    properties: .init(
                        title: .init(type: "STRING", items: nil),
                        tags: .init(
                            type: "ARRAY",
                            items: .init(type: "STRING")
                        )
                    ),
                    required: ["title", "tags"],
                    propertyOrdering: ["title", "tags"]
                )
            )
        )
    }

    struct Content: Codable {
        let parts: [Part]
    }

    struct Part: Codable {
        let text: String
    }

    struct GenerationConfig: Codable {
        let responseMimeType: String
        let responseSchema: ResponseSchema
    }

    struct ResponseSchema: Codable {
        let type: String
        let properties: Properties
        let required: [String]
        let propertyOrdering: [String]

        struct Properties: Codable {
            let title: Property
            let tags: Property

            struct Property: Codable {
                let type: String
                let items: Items?

                struct Items: Codable {
                    let type: String
                }
            }
        }
    }
}
