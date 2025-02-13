//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var holidayVM: HolidayViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @Binding var gridHeight: CGFloat
    
    @Binding var showDailyView: Bool
    
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
                            let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: prevDate)
                            CalendarCellView(showDailyView: $showDailyView, cellDate: prevDate, currentMonthDay: false, isToday: isToday)
                                .frame(height: cellHeight)
                        }
                    }
                    
                    // 현재 달의 날짜들을 cell에 넣음
                    ForEach(0..<numberCurrentMonthDays, id: \.self) { day in
                        let currentDate: Date = calendarVM.getDate(value: 0, day: day + 1)
                        let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: currentDate)
                        
                        CalendarCellView(showDailyView: $showDailyView, cellDate: currentDate, currentMonthDay: true, isToday: isToday)
                            .frame(height: cellHeight)
                    }
                    
                    // 현재 달의 날짜들을 전부 채웠는데 cell이 35개(5행)보다 적은지 많은지 구분
                    // 적으면 35개가 될때까지 다음 달의 날짜를 채우고, 많으면 42개가 될때까지 채움
                    let sumPrevCurrentCount = currentFirstWeekday + numberCurrentMonthDays
                    let remainCount = sumPrevCurrentCount <= 35 ? 35 - sumPrevCurrentCount : 42 - sumPrevCurrentCount
                    
                    ForEach(0..<remainCount, id: \.self) { day in
                        let nextDate: Date = calendarVM.getDate(value: 1, day: day + 1)
                        let isToday: Bool = manager.basicDateString(date: Date()) == manager.basicDateString(date: nextDate)
                        
                        CalendarCellView(showDailyView: $showDailyView, cellDate: nextDate, currentMonthDay: false, isToday: isToday)
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
    
    @EnvironmentObject var calendarVM: CalendarViewModel
    @EnvironmentObject var holidayVM: HolidayViewModel
    @EnvironmentObject var eventVM: EventViewModel
    
    @Binding var showDailyView: Bool
    
    let manager = DateFormatManager.shared
    
    var cellDate: Date
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
        .background(.neutral100)
        .onTapGesture {
            self.showDailyView = true
            eventVM.setDay(date: cellDate)
            print("cell clicked.")
        }
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
                        MarqueeText(text: dateName)
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
                        MarqueeText(text: "\(moreEvent != 0 ? "+\(moreEvent)" : event.title ?? "nil")")
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
    
    @State var text: String = "회의 싫어요! "
    @State var storedSize: CGSize = .zero
    @State var offset: CGFloat = .zero
    
    @State var changeText: Int = 0
    
    var body: some View {
        GeometryReader { scrollGeometry in
            ScrollView(.horizontal) {
                HStack {
                    Text(text)
                        .fixedSize()
                        .frame(maxWidth: .infinity)
                        .offset(x: offset)
                        .background {
                            GeometryReader { textGeo in
                                Color.clear
                                    .onAppear {
                                        if textGeo.size.width > scrollGeometry.size.width {
                                            text.append("       ")
                                            changeText += 1
                                        }
                                    }
                                    .onChange(of: changeText, perform: { newValue in
                                        storedSize = textGeo.size
                                        let newText = text
                                        text.append(newText)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                            withAnimation(.linear(duration: 5)) {
                                                offset = -storedSize.width
                                            }
                                        }
                                    })
                                    .onReceive(Timer.publish(every: 8, on: .main, in: .default).autoconnect()) { _ in
                                        offset = 0
                                        withAnimation(.linear(duration: 5)) {
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
    
    let basicDateFormatter: DateFormatter
    let fullDateFormatter: DateFormatter
    let timeFormatter: DateFormatter
    let dailyViewTitleFormatter: DateFormatter
    
    private init() {
        basicDateFormatter = DateFormatter()
        basicDateFormatter.dateFormat = "YYYYMMdd"
        fullDateFormatter = DateFormatter()
        fullDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "M월 d일 a h:mm"
        dailyViewTitleFormatter = DateFormatter()
        dailyViewTitleFormatter.locale = Locale(identifier: "ko_KR")
        dailyViewTitleFormatter.dateFormat = "M월 d일 EEEE"
    }
    
    func basicDateString(date: Date) -> String {
        return basicDateFormatter.string(from: date)
    }

    func removeHypenDateString(textDate: String) -> String {
        return String(textDate.prefix(10)).replacingOccurrences(of: "-", with: "")
    }
    
    func timeToString(textDate: String) -> String {
        if let date = fullDateFormatter.date(from: textDate) {
            let timeString = timeFormatter.string(from: date)
            return timeString
        } else {
            return "timeToString() failed."
        }
    }
    
    func dailyViewTitleFormat(date: Date) -> String {
        return dailyViewTitleFormatter.string(from: date)
    }
}

#Preview {
    @State var gridHeight: CGFloat = 650.0
    @State var showDailyView: Bool = false
    CalendarGrid( gridHeight: $gridHeight, showDailyView: $showDailyView)
        .environmentObject(CalendarViewModel())
        .environmentObject(HolidayViewModel())
        .environmentObject(EventViewModel())
}

