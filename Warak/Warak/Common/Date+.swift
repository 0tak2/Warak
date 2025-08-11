//
//  Date+.swift
//  Warak
//
//  Created by 임영택 on 8/11/25.
//

import Foundation

extension Date {
    var localizedDescription: String {
        // TODO: i18n
        return localizedKoreanDescription
    }
    
    var localizedKoreanDescription: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월 d일 (E) a h시 mm분"
        
        return formatter.string(from: self)
    }
}
