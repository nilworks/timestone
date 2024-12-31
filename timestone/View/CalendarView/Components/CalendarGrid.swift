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
                    let prevDaysCount: Int = calendarVM.firstWeekdayOfMonth() - 1
                    let countPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 총 몇일
                    let countMonthDays: Int = calendarVM.numberOfDays()
                    let rowHeight = prevDaysCount + countMonthDays > 35 ? geometry.size.height / 7 : geometry.size.height / 6
                    if prevDaysCount >= 1 {
                        ForEach((0..<prevDaysCount).reversed(), id: \.self) { i in
                            CalendarCellView(cellTitle: countPrevMonthDays - i, currentMonthDay: false)
                                .frame(height: rowHeight)
                        }
                    }
                    ForEach(0..<countMonthDays, id: \.self) { day in
                        CalendarCellView(cellTitle: day + 1, currentMonthDay: true)
                            .frame(height: rowHeight)
                    }
                    
                    if (prevDaysCount + countMonthDays) <= 35 {
                        let remainNextMonthDays: Int = 35 - (prevDaysCount + countMonthDays)
                        ForEach(0..<remainNextMonthDays, id: \.self) { day in
                            CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                                .frame(height: rowHeight)
                        }
                    }
                    
                    if (prevDaysCount + countMonthDays) > 35 {
                        let remainNextMonthDays: Int = 42 - (prevDaysCount + countMonthDays)
                        ForEach(0..<remainNextMonthDays, id: \.self) { day in
                            CalendarCellView(cellTitle: day + 1, currentMonthDay: false)
                                .frame(height: rowHeight)
                        }
                    }
                }
                .background(.green)
                .frame(maxHeight: geometry.size.height, alignment: .top)
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

