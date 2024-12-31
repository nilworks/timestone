//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarVM
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    let currentFirstWeekday: Int = calendarVM.firstWeekdayOfMonth() - 1 // 현재 달 1일 요일
                    let numberPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 날짜 개수
                    let numberCurrentMonthDays: Int = calendarVM.numberOfDays() // 현재 달 날짜 개수
                    let cellHeight = currentFirstWeekday + numberCurrentMonthDays > 35 ?  geometry.size.height / 7 : geometry.size.height / 6 // 행 개수에 따른 cell 높이
                    
                    // 현재 달의 1일이 일요일이 아닐 경우
                    if currentFirstWeekday >= 1 {
                        // 이전 달의 남은 날짜를 cell에 넣음
                        ForEach((0..<currentFirstWeekday).reversed(), id: \.self) { i in
                            CalendarCellView(cellTitle: numberPrevMonthDays - i, currentMonthDay: false)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: true)
                            .frame(height: cellHeight)
                    }
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    if (currentFirstWeekday + numberCurrentMonthDays) <= 35 {
                        let remainNextMonthDays: Int = 35 - (currentFirstWeekday + numberCurrentMonthDays)
                        ForEach(0..<remainNextMonthDays, id: \.self) { day in
                            CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                                .frame(height: cellHeight)
                        }
                    } else {
                        let remainNextMonthDays: Int = 42 - (currentFirstWeekday + numberCurrentMonthDays)
                        ForEach(0..<remainNextMonthDays, id: \.self) { day in
                            CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                                .frame(height: cellHeight)
                        }
                    }
                }
                .background(.green)
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
    }
}

struct CalendarCellView: View {
    var cellTitle: Int = 0
    var currentMonthDay: Bool = true
    
    var body: some View {
        VStack {
            Text("\(cellTitle)")
                .foregroundStyle(currentMonthDay ? Color.black : Color.gray)
            Spacer()
        }
        .frame(maxHeight: .infinity)
        .background(.yellow)
        
    }
}

#Preview {
    CalendarGrid()
        .environmentObject(CalendarVM())
}

