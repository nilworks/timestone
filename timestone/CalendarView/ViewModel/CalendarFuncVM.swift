//
//  CalendarFuncVM.swift
//  timestone
//
//  Created by 조성빈 on 12/22/24.
//

import Foundation

class CalendarFuncVM: ObservableObject {
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
    
}
