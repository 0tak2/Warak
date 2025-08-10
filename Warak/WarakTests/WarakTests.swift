//
//  WarakTests.swift
//  WarakTests
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import Testing
@testable import Warak

struct WarakTests {
    @Test func testGeminiPrediction() async throws {
        let geminiEndpoints = GeminiEndpoints()
        await #expect(throws: Never.self) {
            let geminiResponse = try await geminiEndpoints.requestPrediction(inputText: "명상은 나를 현재로 불러들이는 부드러운 손길이다. "
                                                                       + "아침 햇살이 커튼 틈으로 스며들면, 나는 눈을 감고 호흡에 귀를 기울인다. "
                                                                       + "숨이 들어오고 나가는 그 단순한 리듬 속에서 불필요한 생각들은 저절로 가라앉는다. "
                                                                       + "어제의 후회도 내일의 걱정도 잠시 자리를 비운다. "
                                                                       + "그 고요한 빈자리에서 나는 비로소 온전히 나와 마주한다.")
            let prediction = try geminiResponse.decodePrediction()
            print(prediction)
        }
    }
}
