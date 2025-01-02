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
    
    
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 1), count: 7), spacing: 0) {
                    let currentFirstWeekday: Int = calendarVM.firstWeekdayOfMonth() - 1 // 현재 달 1일 요일
                    let numberPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 날짜 개수
                    let numberCurrentMonthDays: Int = calendarVM.numberOfDays() // 현재 달 날짜 개수
                    let cellHeight = currentFirstWeekday + numberCurrentMonthDays > 35 ?  gridHeight / 6 : gridHeight / 5 // 행 개수에 따른 cell 높이
                    
                    // 현재 달의 1일이 일요일이 아닐 경우
                    if currentFirstWeekday >= 1 {
                        // 이전 달의 남은 날짜를 cell에 넣음
                        ForEach((0..<currentFirstWeekday).reversed(), id: \.self) { i in
                            let isToday: Bool = Date().calendarDateString() == calendarVM.getDate(value: -1, day: numberPrevMonthDays - i).calendarDateString()
                            
                            CalendarCellView(cellTitle: numberPrevMonthDays - i, currentMonthDay: false, isToday: isToday)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        let isToday: Bool = Date().calendarDateString() == calendarVM.getDate(value: 0, day: day + 1).calendarDateString()
                        
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: true, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    let sumPrevCurrentCount = currentFirstWeekday + numberCurrentMonthDays
                    let remainCount = sumPrevCurrentCount <= 35 ? 35 - sumPrevCurrentCount : 42 - sumPrevCurrentCount
                    
                    ForEach(0..<remainCount, id: \.self) { day in
                        let isToday: Bool = Date().calendarDateString() == calendarVM.getDate(value: 1, day: day + 1).calendarDateString()
                        
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: false, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    
                    
                }
                .background(.green)
                .frame(maxHeight: .infinity)
                .onAppear {
                    gridHeight = geometry.size.height
                }
            }
        }
    }
}

struct CalendarCellView: View {
    var cellTitle: Int
    var currentMonthDay: Bool
    var isToday: Bool
    
    init(cellTitle: Int, currentMonthDay: Bool = false, isToday: Bool = true) {
        self.cellTitle = cellTitle
        self.currentMonthDay = currentMonthDay
        self.isToday = isToday
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundStyle(isToday ? .primary100 : .clear)
                .scaleEffect(0.6)
                .overlay {
                    Text("\(cellTitle)")
                        .foregroundStyle(currentMonthDay ? Color.black : Color.gray)
                }
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(.yellow)
        
    }
}


extension Date {
    func calendarDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy dd"
        return formatter.string(from: self)
    }
}


#Preview {
    @State var gridHeight: CGFloat = 654.0
    CalendarGrid( gridHeight: $gridHeight)
        .environmentObject(CalendarVM())
}

