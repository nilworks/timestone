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
    @State private var showDailyView: Bool = true
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 달력 상단 <, > 버튼 스택
                HStack {
                    Button {
                        calendarVM.changeMonth(value: -1)
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button {
                        // action
                    } label: {
                        Text(calendarVM.dateToStringYearMonth())
                            .font(.system(size: 27))
                            .fontWeight(.semibold)
                            .padding(.bottom, showDailyView ? 0 : 15)
                    }

                    Spacer()
                    
                    Button {
                        calendarVM.changeMonth(value: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                    }

                }
                .foregroundStyle(.neutral05)
                .padding(.horizontal, 17)
                .padding(.vertical, 5)
                if !showDailyView {
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
                    CalendarGrid(gridHeight: $gridHeight)
                        .environmentObject(calendarVM)
                        .environmentObject(holidayVM)
                                        .frame(maxHeight: .infinity)
                } else {
                    // show DailyView
                    DailyView()
                        .environmentObject(eventVM)
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
                    
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button {
                            // action
                            showDailyView = true
                        } label: {
                            Image(systemName: "1.lane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.neutral05)
                        }
                    })
                    
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button {
                            // action
                        } label: {
                            Image(systemName: "7.lane")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundStyle(.neutral05)
                        }
                    })
                    
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button {
                            // action
                        } label: {
                            Image(systemName: "bell")
                                .font(.system(size: 22))
                                .foregroundStyle(.neutral05)
                        }
                    })
                }
                .background(.neutral100)
        }
    }
}

#Preview {
    ShowCalendarView()
}
