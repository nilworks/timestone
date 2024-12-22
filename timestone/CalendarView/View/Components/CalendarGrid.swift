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
        VStack {
            Text("hi")
        }
    }
}

#Preview {
    CalendarGrid()
        .environmentObject(CalendarFuncVM())
}
