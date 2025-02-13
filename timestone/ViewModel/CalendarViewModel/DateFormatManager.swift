//
//  DateFormatManager.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

//MARK: - DateFormat 관련 싱글톤
class DateFormatManager {
    static let shared = DateFormatManager()
    
    let basicDateFormatter: DateFormatter
    let fullDateFormatter: DateFormatter
    let timeFormatter: DateFormatter
    let dailyViewTitleFormatter: DateFormatter
    
    private init() {
        basicDateFormatter = DateFormatter()
        basicDateFormatter.dateFormat = "YYYYMMdd"
        fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "M월 d일 a h:mm"
        dailyViewTitleFormatter = DateFormatter()
        dailyViewTitleFormatter.locale = Locale(identifier: "ko_KR")
        dailyViewTitleFormatter.dateFormat = "M월 d일 EEEE"
    }
    
    func basicDateString(date: Date) -> String {
        return basicDateFormatter.string(from: date)
    }

    func removeHypenDateString(textDate: String) -> String {
        return String(textDate.prefix(10)).replacingOccurrences(of: "-", with: "")
    }
    
    func timeToString(textDate: String) -> String {
        if let date = fullDateFormatter.date(from: textDate) {
            let timeString = timeFormatter.string(from: date)
            return timeString
        } else {
            return "timeToString() failed."
        }
    }
    
    func dailyViewTitleFormat(date: Date) -> String {
        return dailyViewTitleFormatter.string(from: date)
    }
}
