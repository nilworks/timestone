//
//  CalendarVM.swift
//  timestone
//
//  Created by 조성빈 on 12/26/24.
//

import Foundation

class CalendarViewModel: ObservableObject {
    @Published var weekDays: [String] = ["일", "월", "화", "수", "목", "금", "토"]
    
    @Published var month: Date = Date() {
        didSet {
            dateToStringYearMonth()
            makeCalendarArray()
        }
    }
    
    @Published var calendarArray: [[CalendarDay]] = []
    @Published var calendarAryIndex: [Int] = []
    @Published var weekIndex: Int = 0
    @Published var isCalendarReady: Bool = false
    let dateManager = DateFormatManager.shared
    
    let calendar = Calendar.current
    
    // yyyy년 m월 문자열 dateformat
    @discardableResult
    func dateToStringYearMonth() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: month)
    }
    
    // value: -1(이전 달), 0(현재 달), 1(다음 달)
    func calculateMonth(value: Int, day: Int) -> Date {
        let changedMonth = calendar.date(byAdding: .month, value: value, to: month)!
        
        
        
        return calendar.date(from: DateComponents(year: calendar.component(.year, from: changedMonth), month: calendar.component(.month, from: changedMonth), day: day)) ?? Date()
    }
    
    func getDay(date: Date) -> Int {
        return calendar.component(.day, from: date)
    }
    
    func getMonth(date: Date) -> Int {
        return calendar.component(.month, from: date)
    }
    
    func getYear(date: Date) -> Int {
        return calendar.component(.year, from: date)
    }
    
    // 이전/다음 달
    func changeMonth(value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: month) {
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
    
    
    
    //MARK: - 주간보기 함수
    func makeCalendarArray() {
        isCalendarReady = false
        calendarArray = [] // 기존 배열 초기화
        calendarAryIndex = []
        
        var count = 0
        
        let currentFirstWeekday = firstWeekdayOfMonth() - 1
        let numberCurrentMonthDays = numberOfDays()
        
        let isSixWeekMonth = currentFirstWeekday + numberCurrentMonthDays > 35
        let totalDays = isSixWeekMonth ? 42 : 35
        
        var tempArray: [CalendarDay] = []
        
        // 현재 달의 첫 번째 날짜 가져오기
        let firstDayOfMonth = startOfMonth(month: month)
        
        // 이전 달 날짜 채우기
        for i in (0..<currentFirstWeekday).reversed() {
            if let prevMonthDate = calendar.date(byAdding: .day, value: -i - 1, to: firstDayOfMonth) {
                let dayOfWeek = dateManager.dayOfWeekFormat(date: prevMonthDate)
                tempArray.append(CalendarDay(date: prevMonthDate, dayOfWeek: dayOfWeek, isCurrentMonth: false))
            }
        }
        
        // 현재 달 날짜 채우기
        for day in 0..<numberCurrentMonthDays {
            if let currentMonthDate = calendar.date(byAdding: .day, value: day, to: firstDayOfMonth) {
                let dayOfWeek = dateManager.dayOfWeekFormat(date: currentMonthDate)
                tempArray.append(CalendarDay(date: currentMonthDate, dayOfWeek: dayOfWeek, isCurrentMonth: true))
            }
        }
        
        // 다음 달 날짜 채우기
        for day in 0..<(totalDays - tempArray.count) {
            if let nextMonthDate = calendar.date(byAdding: .day, value: day + numberCurrentMonthDays, to: firstDayOfMonth) {
                let dayOfWeek = dateManager.dayOfWeekFormat(date: nextMonthDate)
                tempArray.append(CalendarDay(date: nextMonthDate, dayOfWeek: dayOfWeek, isCurrentMonth: false))
            }
        }
        
        // 7개씩 끊어서 calendarArray에 저장
        for chunk in stride(from: 0, to: totalDays, by: 7) {
            let week = Array(tempArray[chunk..<chunk+7])
            calendarArray.append(week)
            calendarAryIndex.append(count)
            count += 1
        }
        
        if calendar.isDate(month, equalTo: Date(), toGranularity: .month) &&
           calendar.isDate(month, equalTo: Date(), toGranularity: .year) {
            self.weekIndex = findCurrentWeekIndex() ?? 0
        } else {
            weekIndex = 0
        }
        
        isCalendarReady = true
    }
    
    // calendarArray에서 오늘 날짜가 속해있는 주 찾기
    func findCurrentWeekIndex() -> Int? {
        let today = Date()
        
        for (index, week) in calendarArray.enumerated() {
            if week.contains(where: { calendar.isDate($0.date, inSameDayAs: today)}) {
                return index
            }
        }
        
        return nil
    }
    
    //weekIndex 조절
    func changeWeek(value: Int) {
        switch value {
        case 1:
            if weekIndex < calendarArray.endIndex - 1 {
                weekIndex += 1
            } else {
                changeMonth(value: 1)
                weekIndex = 0
            }
        case -1:
            if weekIndex > 0 {
                weekIndex -= 1
            } else {
                changeMonth(value: -1)
                    self.weekIndex = self.calendarArray.endIndex - 1
            }
        default:
            print("chagneWeek - invalid value")
        }
    }
}
