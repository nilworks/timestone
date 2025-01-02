//
//  ShowCalendarView.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct ShowCalendarView: View {
    @EnvironmentObject var calendarVM: CalendarVM
    @State private var gridHeight: CGFloat = 0
    
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
                            .padding(.bottom)
                    }

                    Spacer()
                    
                    Button {
                        calendarVM.changeMonth(value: 1)
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                    }

                }
                .padding(.horizontal, 17)
                .background(.red)
                .padding(.vertical, 5)
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
                    ForEach(calendarVM.weekDays, id: \.self) { day in
                        Text(day)
                    }
                }
                .background(.green)
                .padding(.bottom, 5)
                CalendarGrid(gridHeight: $gridHeight)
                                    .frame(maxHeight: .infinity)
                                    .background(.blue)
                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(.clear)
            }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button {
                            // action
                        } label: {
                            Image("CalendarIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .background(.red)
                        }
                    })
                    
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button {
                            // action
                        } label: {
                            Image(systemName: "bell")
                                .font(.system(size: 22))
                        }
                    })
                }
        }
    }
}

#Preview {
    ShowCalendarView()
        .environmentObject(CalendarVM())
}
