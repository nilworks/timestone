//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarFuncVM
    
    let todayDate: Date = Date()
    
    var body: some View {
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                let prevDaysCount: Int = todayDate.firstWeekdayOfMonth() - 1
                let countPrevMonthDays: Int = todayDate.numberOfDaysPrevMonth() // 지난 달 총 몇일
                let countMonthDays: Int = todayDate.numberOfDays()
                if prevDaysCount >= 1 {
                    ForEach((0..<prevDaysCount).reversed(), id: \.self) { i in
                        CalendarCellView(cellTitle: i)
                    }
                }
                ForEach(0..<countMonthDays, id: \.self) { day in
                    CalendarCellView(cellTitle: day + 1)
                }
                
                if (prevDaysCount + countMonthDays) < 35 {
                    let remainNextMonthDays: Int = 35 - (prevDaysCount + countMonthDays)
                    ForEach(0..<remainNextMonthDays, id: \.self) { day in
                        CalendarCellView(cellTitle: day + 1)
                    }
                }
            }
            .background(.green)
        }
    }
}


struct CalendarCellView: View {
    @State var cellTitle: Int = 0
    
    var body: some View {
        VStack {
            Text("\(cellTitle)")
        }
    }
}

#Preview {
    CalendarGrid()
        .environmentObject(CalendarFuncVM())
}
