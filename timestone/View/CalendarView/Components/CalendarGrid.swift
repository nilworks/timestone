//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var holidayVM: HolidayViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @Binding var gridHeight: CGFloat
    
    @Binding var showDailyView: Bool
    
    let manager = DateFormatManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                    let currentFirstWeekday: Int = calendarVM.firstWeekdayOfMonth() - 1 // 현재 달 1일 요일
                    let numberPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 날짜 개수
                    let numberCurrentMonthDays: Int = calendarVM.numberOfDays() // 현재 달 날짜 개수
                    let cellHeight = currentFirstWeekday + numberCurrentMonthDays > 35 ?  gridHeight / 6 : gridHeight / 5
                    
                    // 현재 달의 1일이 일요일이 아닐 경우
                    if currentFirstWeekday >= 1 {
                        // 이전 달의 남은 날짜를 cell에 넣음
                        ForEach((0..<currentFirstWeekday).reversed(), id: \.self) { i in
                            let prevDate: Date = calendarVM.getDate(value: -1, day: numberPrevMonthDays - i)
                            let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: prevDate)
                            CalendarCellView(showDailyView: $showDailyView, cellDate: prevDate, currentMonthDay: false, isToday: isToday)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        let currentDate: Date = calendarVM.getDate(value: 0, day: day + 1)
                        let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: currentDate)
                        
                        CalendarCellView(showDailyView: $showDailyView, cellDate: currentDate, currentMonthDay: true, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    let sumPrevCurrentCount = currentFirstWeekday + numberCurrentMonthDays
                    let remainCount = sumPrevCurrentCount <= 35 ? 35 - sumPrevCurrentCount : 42 - sumPrevCurrentCount
                    
                    ForEach(0..<remainCount, id: \.self) { day in
                        let nextDate: Date = calendarVM.getDate(value: 1, day: day + 1)
                        let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: nextDate)
                        
                        CalendarCellView(showDailyView: $showDailyView, cellDate: nextDate, currentMonthDay: false, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    // 달력 높이
                    gridHeight = geometry.size.height
                    holidayVM.load(year: calendarVM.getYear(date: calendarVM.month))
                }
                .onChange(of: calendarVM.getYear(date: calendarVM.month)) { newYear in
                    holidayVM.load(year: newYear)
                }
            }
            .background(.neutral100)
        }
    }
}

#Preview {
    @State var gridHeight: CGFloat = 650.0
    @State var showDailyView: Bool = false
    CalendarGrid( gridHeight: $gridHeight, showDailyView: $showDailyView)
        .environmentObject(CalendarViewModel())
        .environmentObject(HolidayViewModel())
        .environmentObject(EventViewModel())
}

