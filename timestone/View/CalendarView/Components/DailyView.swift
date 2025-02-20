//
//  DailyView.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

struct DailyView: View {
    @EnvironmentObject var eventVM: EventViewModel
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 1)) {
                ForEach(eventVM.getDailyEvents(), id: \.self) { event in
                    DailyCellView(event: event)
                }
            }
            .padding(.top, 30)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
}


#Preview {
    DailyView()
        .environmentObject(EventViewModel())
}
