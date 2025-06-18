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
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 1), alignment: .center) {
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

