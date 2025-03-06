//
//  CalendarCellView.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//
import SwiftUI

struct CalendarCellView: View {
    let dummyEvents: [Event] = EventInfo().dummyEvents
    
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var holidayVM: HolidayViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @Binding var showDailyView: Bool
    
    let manager = DateFormatManager.shared
    
    var cellDate: Date
    var isSixRowMonth: Bool
    var currentMonthDay: Bool
    var isToday: Bool
    var isHoliday: Bool {
        return holidayVM.holidays.contains { $0.locdate == manager.basicDateString(date: cellDate) }
    }
    var holidayName: String {
        holidayVM.holidays.first { $0.locdate == manager.basicDateString(date: cellDate) }?.dateName ?? "..?"
    }
    var isExistEvent: Bool {
        let existStartTime: Bool = dummyEvents.contains { manager.removeHypenDateString(textDate: $0.startTime) == manager.basicDateString(date: cellDate) }
        let existEndTime: Bool = dummyEvents.contains {
            manager.removeHypenDateString(textDate: $0.endTime) == manager.basicDateString(date: cellDate)
        }
        return existStartTime || existEndTime
    }
    
    var events: [Event]? {
        return dummyEvents.filter { manager.removeHypenDateString(textDate: $0.startTime) == manager.basicDateString(date: cellDate) || manager.removeHypenDateString(textDate: $0.endTime) == manager.basicDateString(date: cellDate) }
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundStyle(isToday ? .primary100 : .clear)
                .frame(maxWidth: isSixRowMonth ? 27 : 35, maxHeight: isSixRowMonth ? 27 : 35)
                .overlay {
                    Text("\(calendarVM.getDay(date: cellDate))")
                        .foregroundStyle(!currentMonthDay ? .neutral70 : self.isToday ? .neutral100 : .neutral05)
                        .font(.bodyMedium)
                }
            GeometryReader { geometry in
                VStack(spacing: 3) {
                    if isHoliday {
                        EventCell(isHoliday: isHoliday, dateName: holidayName)
                            .frame(height: geometry.size.height / 3)
                    }
                    if let events = events {
                        ForEach(Array(events.prefix(isHoliday ? 1 : 2).enumerated()), id: \.0) { index, event in
                            EventCell(isHoliday: false, dateName: holidayName, isExistEvent: isExistEvent, event: event)
                                .frame(height: geometry.size.height / 3)
                        }
                        if events.prefix(isHoliday ? 1 : 2).count < events.count {
                            EventCell(isExistEvent: true, moreEvent: (events.count - events.prefix(isHoliday ? 1 : 2).count))
                                .frame(height: geometry.size.height / 3)
                        }
                    }
                    Spacer()
                }
                .opacity(currentMonthDay ? 1 : 0.4)
            }
            Rectangle()
                .frame(height: 1.5)
                .foregroundStyle(.neutral80)
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 5)
        .background(.neutral100)
        .onTapGesture {
            self.showDailyView = true
            eventVM.setDay(date: cellDate)
            print("cell clicked.")
        }
    }
}
