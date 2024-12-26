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
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                let prevDaysCount: Int = calendarVM.firstWeekdayOfMonth() - 1
                let countPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 총 몇일
                let countMonthDays: Int = calendarVM.numberOfDays()
                if prevDaysCount >= 1 {
                    ForEach((0..<prevDaysCount).reversed(), id: \.self) { i in
                        CalendarCellView(cellTitle: countPrevMonthDays - i, currentMonthDay: false)
                    }
                }
                ForEach(0..<countMonthDays, id: \.self) { day in
                    CalendarCellView(cellTitle: day + 1, currentMonthDay: true)
                }
                
                if (prevDaysCount + countMonthDays) <= 35 {
                    let remainNextMonthDays: Int = 35 - (prevDaysCount + countMonthDays)
                    ForEach(0..<remainNextMonthDays, id: \.self) { day in
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                    }
                }
                
                if (prevDaysCount + countMonthDays) > 35 {
                    let remainNextMonthDays: Int = 42 - (prevDaysCount + countMonthDays)
                    ForEach(0..<remainNextMonthDays, id: \.self) { day in
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                    }
                }
            }
            .background(.green)
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
        }
    }
}

#Preview {
    CalendarGrid()
        .environmentObject(CalendarVM())
}

