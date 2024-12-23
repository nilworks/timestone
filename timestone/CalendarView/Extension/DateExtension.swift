//
//  DateExtension.swift
//  timestone
//
//  Created by 조성빈 on 12/21/24.
//

import SwiftUI

extension Date {
    
    // 특정 월의 시작 일
    func startOfMonth(month: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: month)
        
        return Calendar.current.date(from: components)!
    }
    
    // 특정 월에 존재하는 일 개수
    func numberOfDays() -> Int {
        return Calendar.current.range(of: .day, in: .month, for: self)?.count ?? 0
    }
    
    // 특정 월의 이전 달 일 개수
    func numberOfDaysPrevMonth() -> Int {
        let prevMonth = Calendar.current.date(byAdding: .month, value: -1, to: self)!
        return Calendar.current.range(of: .day, in: .month, for: prevMonth)?.count ?? 0
    }
    
    // 특정 월/1일의 요일
    func firstWeekdayOfMonth() -> Int {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        let firstDayOfMonth = Calendar.current.date(from: components)!
        
        return Calendar.current.component(.weekday, from: firstDayOfMonth)
    }
    
}
