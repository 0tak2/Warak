//
//  AppStaticProperties.swift
//  Warak
//
//  Created by 임영택 on 8/10/25.
//

import Foundation
import os.log

struct AppStaticProperties {
    static var shared: AppStaticProperties = .init()
    
    private let plistName: String = "StaticProperties"
    private let logger = Logger.category("AppStaticProperties")
    
    /// MARK: Loaded Properties
    var geminiApiKey: String = ""
    
    private init() {
        if let plistRaw = loadPlist() {
            geminiApiKey = plistRaw["GEMINI_API_KEY"] ?? ""
            // TODO: 다른 프로퍼티 추가 시 여기에서 초기화
        }
    }
    
    private func loadPlist() -> [String: String]? {
        // plist 파일 가져오기 & 파싱
        guard let plistPath = Bundle.main.url(forResource: plistName, withExtension: "plist") else {
            logger.error("cannot get plist: \(plistName).plist")
            return nil
        }
        
        guard let plistData = try? Data(contentsOf: plistPath) else {
            logger.error("cannot get plist data")
            return nil
        }
        
        guard let plist = try? PropertyListSerialization.propertyList(
            from: plistData,
            options: .mutableContainersAndLeaves,
            format: nil
        ) as? [String: String] else {
            logger.error("cannot parse plist data")
            return nil
        }
        
        return plist
    }
}
