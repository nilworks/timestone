//
//  ShowCalendarView.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct ShowCalendarView: View {
    @StateObject var calendarVM: CalendarViewModel = CalendarViewModel()
    @StateObject var holidayVM: HolidayViewModel = HolidayViewModel()
    @StateObject var eventVM: EventViewModel = EventViewModel()
    
    @State private var gridHeight: CGFloat = 0
    @State private var showDailyView: Bool = false
    @State private var showWeekDayView: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 달력 상단 <, > 버튼 스택
                HStack {
                    Button {
                        if !showDailyView && !showWeekDayView {
                            calendarVM.changeMonth(value: -1)
                        } else if showDailyView && !showWeekDayView {
                            eventVM.changeDay(value: -1)
                        } else {
                            calendarVM.changeWeek(value: -1)
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button {
                        // action
                    } label: {
                        Text(!showDailyView ? calendarVM.dateToStringYearMonth() : eventVM.dailyViewTitle())
                            .font(.system(size: 27))
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    Button {
                        if !showDailyView && !showWeekDayView {
                            calendarVM.changeMonth(value: 1)
                        } else if showDailyView && !showWeekDayView {
                            eventVM.changeDay(value: 1)
                        } else {
                            calendarVM.changeWeek(value: 1)
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                    }
                    
                }
                .foregroundStyle(.neutral05)
                .padding(.horizontal, 17)
                .padding(.bottom, 15)
                .padding(.top, 15)
                if !showDailyView && !showWeekDayView {
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 7)) {
                        ForEach(calendarVM.weekDays, id: \.self) { day in
                            Text(day)
                                .foregroundStyle(.neutral05)
                        }
                    }
                    .padding(.bottom, 5)
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundStyle(.neutral80)
                    CalendarGrid(gridHeight: $gridHeight, showDailyView: $showDailyView)
                        .environmentObject(calendarVM)
                        .environmentObject(holidayVM)
                        .environmentObject(eventVM)
                        .frame(maxHeight: .infinity)
                } else if showDailyView && !showWeekDayView {
                    // show DailyView
                    DailyView()
                        .environmentObject(eventVM)
                } else {
                    //TODO: - 주간 보기 뷰
                    if calendarVM.isCalendarReady {
                        WeekDayView()
                            .environmentObject(calendarVM)
                            .environmentObject(eventVM)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button {
                        // action
                        showDailyView = false
                    } label: {
                        Image("CalendarIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                    }
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button {
                        // action
                        showWeekDayView.toggle()
                    } label: {
                        Image(systemName: "bell")
                            .font(.system(size: 22))
                            .foregroundStyle(.neutral05)
                    }
                })
            }
            .background(.neutral100)
            .onAppear {
                calendarVM.makeCalendarArray()
            }
        }
    }
}

#Preview {
    ShowCalendarView()
}
