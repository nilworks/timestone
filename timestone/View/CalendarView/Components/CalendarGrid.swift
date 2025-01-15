//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarVM
    @Binding var gridHeight: CGFloat
    
    @EnvironmentObject var holidayVM: HolidayVM

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
                            let isToday: Bool = Date().calendarDateString() == prevDate.calendarDateString()
                            
                            CalendarCellView(cellDate: prevDate, currentMonthDay: false, isToday: isToday)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        let currentDate: Date = calendarVM.getDate(value: 0, day: day + 1)
                        let isToday: Bool = Date().calendarDateString() == currentDate.calendarDateString()
                        
                        CalendarCellView(cellDate: currentDate, currentMonthDay: true, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    let sumPrevCurrentCount = currentFirstWeekday + numberCurrentMonthDays
                    let remainCount = sumPrevCurrentCount <= 35 ? 35 - sumPrevCurrentCount : 42 - sumPrevCurrentCount
                    
                    ForEach(0..<remainCount, id: \.self) { day in
                        let nextDate: Date = calendarVM.getDate(value: 1, day: day + 1)
                        let isToday: Bool = Date().calendarDateString() == nextDate.calendarDateString()
                        
                        CalendarCellView(cellDate: nextDate, currentMonthDay: false, isToday: isToday)
                            .frame(height: cellHeight)
                    }  
                }
                .background(.green)
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

        }
    }
}

struct CalendarCellView: View {
    @EnvironmentObject var calendarVM: CalendarVM
    @EnvironmentObject var holidayVM: HolidayVM
    
    var cellDate: Date
    var currentMonthDay: Bool
    var isToday: Bool
    var isHoliday: Bool {
        return holidayVM.holidays.contains { $0.locdate == cellDate.calendarDateString() }
    }
    var holidayName: String {
        holidayVM.holidays.first { $0.locdate == cellDate.calendarDateString() }?.dateName ?? "..?"
    }
    
    init(cellDate: Date, currentMonthDay: Bool = false, isToday: Bool = true) {
        self.cellDate = cellDate
        self.currentMonthDay = currentMonthDay
        self.isToday = isToday
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundStyle(isToday ? .primary100 : .clear)
                .frame(maxWidth: 40, maxHeight: 40)
                .padding(.top, 5)
                .overlay {
                    Text("\(calendarVM.getDay(date: cellDate))")
                        .foregroundStyle(currentMonthDay ? Color.black : Color.gray)
                }
            Spacer()
            VStack(spacing: 2) {
                eventCell(isHoliday: isHoliday, dateName: holidayName)
                    .frame(maxHeight: 23)
                Spacer()
            }
            Rectangle()
                .frame(height: 1.5)
                .foregroundStyle(.neutral80)
        }
        .frame(maxHeight: .infinity)
        .background(.yellow)
    }
}

struct eventCell: View {
    var isHoliday: Bool = false
    var dateName: String = "공휴일"
    var currentMonthDay: Bool = false
    var isExistEvent: Bool = false
//    var event: Event = Event(id: , date: , title: , ... )
    
    var body: some View {
        VStack {
            if isHoliday {
                Rectangle()
                    .foregroundStyle(.neutral10)
                    .padding(.horizontal, 1)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        Text("\(dateName)")
                            .font(.system(size: 13))
                    }
            }
            if isExistEvent {
                Rectangle()
                    .foregroundStyle(.neutral10)
                    .padding(.horizontal, 1)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
//                        Text("\(event.title)")
//                            .font(.system(size: 13))
                    }
            }
        }
    }
}


extension Date {
    func calendarDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        return formatter.string(from: self)
    }
}


#Preview {
    @State var gridHeight: CGFloat = 650.0
    CalendarGrid( gridHeight: $gridHeight)
        .environmentObject(CalendarVM())
        .environmentObject(HolidayVM())
}

