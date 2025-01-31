//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarVM
    @EnvironmentObject var holidayVM: HolidayVM
    
    @Binding var gridHeight: CGFloat
    
    let manager = DateFormatManager.shared
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7), spacing: 0) {
                    let currentFirstWeekday: Int = calendarVM.firstWeekdayOfMonth() - 1 // 현재 달 1일 요일
                    let numberPrevMonthDays: Int = calendarVM.numberOfDaysPrevMonth() // 지난 달 날짜 개수
                    let numberCurrentMonthDays: Int = calendarVM.numberOfDays() // 현재 달 날짜 개수
                    let cellHeight = currentFirstWeekday + numberCurrentMonthDays > 35 ?  gridHeight / 6 : gridHeight / 5
                    
                    // 현재 달의 1일이 일요일이 아닐 경우
                    if currentFirstWeekday >= 1 {
                        // 이전 달의 남은 날짜를 cell에 넣음
                        ForEach((0..<currentFirstWeekday).reversed(), id: \.self) { i in
                            let prevDate: Date = calendarVM.getDate(value: -1, day: numberPrevMonthDays - i)
                            let isToday: Bool = manager.dateString(date: Date()) == manager.dateString(date: prevDate)
                            CalendarCellView(cellDate: prevDate, currentMonthDay: false, isToday: isToday)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        let currentDate: Date = calendarVM.getDate(value: 0, day: day + 1)
                        let isToday: Bool = manager.dateString(date: Date()) == manager.dateString(date: currentDate)
                        
                        CalendarCellView(cellDate: currentDate, currentMonthDay: true, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    let sumPrevCurrentCount = currentFirstWeekday + numberCurrentMonthDays
                    let remainCount = sumPrevCurrentCount <= 35 ? 35 - sumPrevCurrentCount : 42 - sumPrevCurrentCount
                    
                    ForEach(0..<remainCount, id: \.self) { day in
                        let nextDate: Date = calendarVM.getDate(value: 1, day: day + 1)
                        let isToday: Bool = manager.dateString(date: Date()) == manager.dateString(date: nextDate)
                        
                        CalendarCellView(cellDate: nextDate, currentMonthDay: false, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .onAppear {
                    // 달력 높이
                    gridHeight = geometry.size.height
                    holidayVM.load(year: calendarVM.getYear(date: calendarVM.month))
                }
                .onChange(of: calendarVM.getYear(date: calendarVM.month)) { newYear in
                    holidayVM.load(year: newYear)
                }
            }
            .background(.neutral100)
        }
    }
}

struct CalendarCellView: View {
    let dummyEvents: [Event] = EventInfo().dummyEvents
    
    @EnvironmentObject var calendarVM: CalendarVM
    @EnvironmentObject var holidayVM: HolidayVM
    
    let manager = DateFormatManager.shared
    
    var cellDate: Date
    var currentMonthDay: Bool
    var isToday: Bool
    var isHoliday: Bool {
        return holidayVM.holidays.contains { $0.locdate == manager.dateString(date: cellDate) }
    }
    var holidayName: String {
        holidayVM.holidays.first { $0.locdate == manager.dateString(date: cellDate) }?.dateName ?? "..?"
    }
    var isExistEvent: Bool {
        let existStartTime: Bool = dummyEvents.contains { manager.formattedDateString(textDate: $0.startTime) == manager.dateString(date: cellDate) }
        let existEndTime: Bool = dummyEvents.contains {
            manager.formattedDateString(textDate: $0.endTime) == manager.dateString(date: cellDate)
        }
        return existStartTime || existEndTime
    }
    
    var events: [Event]? {
        return dummyEvents.filter { manager.formattedDateString(textDate: $0.startTime) == manager.dateString(date: cellDate) || manager.formattedDateString(textDate: $0.endTime) == manager.dateString(date: cellDate) }
    }
    
    init(cellDate: Date, currentMonthDay: Bool = false, isToday: Bool = true) {
        self.cellDate = cellDate
        self.currentMonthDay = currentMonthDay
        self.isToday = isToday
    }
    
    var body: some View {
        VStack {
            Circle()
                .foregroundStyle(isToday ? .primary100 : .clear)
                .frame(maxWidth: 35, maxHeight: 35)
                .overlay {
                    Text("\(calendarVM.getDay(date: cellDate))")
                        .foregroundStyle(!currentMonthDay ? .neutral70 : self.isToday ? .neutral100 : .neutral05)
                        .font(.bodyMedium)
                }
            GeometryReader { geometry in
                VStack(spacing: 3) {
                    if isHoliday {
                        eventCell(isHoliday: isHoliday, dateName: holidayName)
                            .frame(height: geometry.size.height / 3.5)
                    }
                    if let events = events {
                        ForEach(Array(events.prefix(isHoliday ? 1 : 2).enumerated()), id: \.0) { index, event in
                            eventCell(isHoliday: false, dateName: holidayName, isExistEvent: isExistEvent, event: event)
                                .frame(height: geometry.size.height / 3.5)
                        }
                        if events.prefix(isHoliday ? 1 : 2).count < events.count {
                            eventCell(isExistEvent: true, moreEvent: (events.count - events.prefix(isHoliday ? 1 : 2).count))
                                .frame(height: geometry.size.height / 3.5)
                        }
                    }
                    Spacer()
                }
            }
            Rectangle()
                .frame(height: 1.5)
                .foregroundStyle(.neutral80)
        }
        .frame(maxHeight: .infinity)
        .padding(.top, 5)
    }
}

struct eventCell: View {
    var isHoliday: Bool = false
    var dateName: String = "공휴일"
    var currentMonthDay: Bool = false
    var isExistEvent: Bool = false
    var event: Event = Event(title: nil, alarm: false, startTime: "2025-01-30T06:55", endTime: "2025-01-30T07:55", notes: nil, url: nil, location: nil, images: nil)
    var moreEvent: Int = 0
    
    var body: some View {
        VStack {
            if isHoliday {
                Rectangle()
                    .foregroundStyle(.red)
                    .padding(.horizontal, 1)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        Text("\(dateName)")
                            .transition(.slide)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 3)
                    }
            }
            if isExistEvent {
                Rectangle()
                    .foregroundStyle(.neutral80)
                    .padding(.horizontal, 1)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    .overlay {
                        MarqueeText(text: "\(moreEvent != 0 ? "+\(moreEvent)" : event.title ?? "nil")", font: Font.captionLight)
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                    }
            }
        }
    }
}


//MARK: - 텍스트 슬라이딩 애니메이션(Marquee)
struct MarqueeText: View {
    
    var text: String = "회의 싫어요!"
    var font: Font
    
    @State var storedSize: CGSize = .zero
    @State var offset: CGFloat = .zero
    
    var body: some View {
        GeometryReader { scrollGeometry in
            ScrollView(.horizontal) {
                HStack {
                    Text(text)
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                        .offset(x: offset)
                        .animation(.linear(duration: 0.05 * storedSize.width))
                        .background {
                            GeometryReader { textGeo in
                                Color.clear
                                    .onAppear {
                                        storedSize = textGeo.size
                                        print(textGeo.size.width)
                                        if storedSize.width > scrollGeometry.size.width {
                                            offset = -storedSize.width
                                        }
                                    }
                            }
                        }
                }
                .frame(width: scrollGeometry.size.width, height: scrollGeometry.size.height, alignment: .leading)
            }
            .scrollDisabled(true)
        }
    }
    
}


//MARK: - DateFormat 관련 싱글톤
class DateFormatManager {
    static let shared = DateFormatManager()
    
    let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYYMMdd"
    }
    
    func dateString(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func formattedDateString(textDate: String) -> String {
        return textDate.split(separator: "T")[0].replacingOccurrences(of: "-", with: "")
    }
}

#Preview {
    @State var gridHeight: CGFloat = 650.0
    CalendarGrid( gridHeight: $gridHeight)
        .environmentObject(CalendarVM())
        .environmentObject(HolidayVM())
}

