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
        ScrollView(.vertical) {
            if calendarVM.isCalendarReady,
               calendarVM.calendarArray.indices.contains(calendarVM.weekIndex) {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 1)) {
                    ForEach(calendarVM.calendarArray[calendarVM.weekIndex], id: \.self) { date in
                        WeekDayCellView(date: date)
                        Rectangle()
                            .frame(height: 1.5)
                            .foregroundStyle(.neutral80)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
    }
}

struct WeekDayCellView: View {
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var eventVM: EventViewModel
    let date: Date
    
    var body: some View {
        HStack(alignment: .top) {
            //TODO: - 날짜
            VStack {
                Text("\(calendarVM.getDay(date: date))")
                    .font(.system(size: 25))
                    .fontWeight(.semibold)
                    .foregroundStyle(.neutral05)
                //                Text("금요일")
                //                    .foregroundStyle(.neutral60)
                //                    .fontWeight(.light)
            }
            VStack {
                //TODO: - DailyCellView using foreach
                ForEach(eventVM.getDailyEvents(day: date), id: \.self) { event in
                    DailyCellView(event: event)
                }
            }
            Spacer()
        }
        .padding(.horizontal, 10)
    }
}
