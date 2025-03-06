//
//  WeekDayCellView.swift
//  timestone
//
//  Created by 조성빈 on 3/6/25.
//

import SwiftUI

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
                .font(.system(size: calendarDay.isCurrentMonth ? 25 : 20))
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
