//
//  WeekDayView.swift
//  timestone
//
//  Created by 조성빈 on 2/27/25.
//

import SwiftUI

struct WeekDayView: View {
    @EnvironmentObject var calendarVM: CalendarViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                if calendarVM.isCalendarReady,
                   calendarVM.calendarArray.indices.contains(calendarVM.weekIndex) {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 1)) {
                        ForEach(calendarVM.calendarArray[calendarVM.weekIndex], id: \.self) { calendarDay in
                            VStack {
                                WeekDayCellView(calendarDay: calendarDay)
                                Rectangle()
                                    .frame(height: 1.5)
                                    .foregroundStyle(.neutral80)
                            }
                            .frame(minHeight: geometry.size.height / 8)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

struct WeekDayCellView: View {
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var eventVM: EventViewModel
    let calendarDay: CalendarDay
    
    var body: some View {
        HStack(alignment: .top) {
            //TODO: - 날짜
            VStack {
                Text(
                    calendarDay.isCurrentMonth ? "\(calendarVM.getDay(date: calendarDay.date))" : "\(calendarVM.getMonth(date: calendarDay.date))/\(calendarVM.getDay(date: calendarDay.date))"
                )
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .foregroundStyle(.neutral05)
                Text("\(calendarDay.dayOfWeek)")
                    .foregroundStyle(.neutral60)
                    .fontWeight(.light)
            }
            VStack {
                //TODO: - DailyCellView using foreach
                ForEach(eventVM.getDailyEvents(day: calendarDay.date), id: \.self) { event in
                    DailyCellView(event: event)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
        .opacity(calendarDay.isCurrentMonth ? 1 : 0.4)
    }
}
