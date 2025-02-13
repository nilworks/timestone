//
//  EventViewModel.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

class EventViewModel: ObservableObject {
    let wholeEvents: [Event] = EventInfo().dummyEvents
    let dateFormatterManager = DateFormatManager.shared
    let calendar = Calendar.current
    
    @Published var day: Date = Date() {
        didSet {
            getDailyEvents()
        }
    }
    
    // 날짜 셀 클릭시 해당 날짜로 초기화
    func setDay(date: Date) {
        self.day = date
    }
    
    // value: -1(어제), 1(내일)
    func changeDay(value: Int) {
        if let newDay = calendar.date(byAdding: .day, value: value, to: day) {
            self.day = newDay
        }
    }
    
    // 일간 보기에서의 해당 날짜 Events 가져오기
    @discardableResult
    func getDailyEvents() -> [Event] {
        // YYYYMMdd
        let formattedDay: String = dateFormatterManager.basicDateString(date: day)
        
        let dailyEvents: [Event] = wholeEvents.filter {
            dateFormatterManager.removeHypenDateString(textDate: $0.startTime) == formattedDay || dateFormatterManager.removeHypenDateString(textDate: $0.endTime) == formattedDay
        }
        
        return dailyEvents
    }
    
    // [String] date to time(DateFormatManager 싱글톤 함수 사용)
    func getTimeToString(textDate: String) -> String {
        return dateFormatterManager.timeToString(textDate: textDate)
    }
    
    // MM월 dd일 EEEE : dailyView의 title
    func dailyViewTitle() -> String {
        return dateFormatterManager.dailyViewTitleFormat(date: day)
    }
}
