//
//  CalendarGrid.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct CalendarGrid: View {
    @EnvironmentObject var calendarVM: CalendarFuncVM
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(), count: 7)) {
            ForEach(calendarVM.weekDays, id: \.self) { day in
                Text(day)
            }
        }
        .background(.green)
    }
}

#Preview {
    CalendarGrid()
        .environmentObject(CalendarFuncVM())
}
