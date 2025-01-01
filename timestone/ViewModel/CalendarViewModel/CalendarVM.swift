//
//  CalendarVM.swift
//  timestone
//
//  Created by 조성빈 on 12/26/24.
//

import Foundation

class CalendarVM: ObservableObject {
    // 1-7의 요일 값으로 Calendar.current.weekdaySymbols[Int] 를 사용해서 더 알잘딱하게 표현할 수 있을지도?
    @Published var weekDays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    @Published var month: Date = Date() {
        didSet {
            dateToStringYearMonth()
        }
    }
    
    
    // yyyy년 m월 문자열 dateformat
    func dateToStringYearMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: month)
    }
    
    // 이전/다음 달
    func changeMonth(value: Int) {
        if let newMonth = Calendar.current.date(byAdding: .month, value: value, to: month) {
            self.month = newMonth
        }
    }
    
    // 특정 월의 시작 일
    func startOfMonth(month: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        
        return Calendar.current.date(from: components)!
    }
    
    // 특정 월에 존재하는 일 개수
    func numberOfDays() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: month)?.count ?? 0
    }
    
    // 특정 월의 이전 달 일 개수
    func numberOfDaysPrevMonth() -> Int {
        let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: month)!
        return Calendar.current.range(of: .day, in: .month, for: prevMonth)?.count ?? 0
    }
    
    // 특정 월/1일의 요일
    func firstWeekdayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
}
