//
//  DailyCellView.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

struct DailyCellView: View {
    @EnvironmentObject var eventVM: EventViewModel
    
    var event: Event
    
    var body: some View {
        HStack {
            Rectangle()
                .frame(height: 40)
                .frame(maxWidth: 2, maxHeight: 40)
                .foregroundStyle(.primary100)
            VStack(alignment: .leading, spacing: 5) {
                Text(event.title ?? "title is nil.")
                    .font(.system(size: 18))
                HStack(spacing: 5) {
                    Text("\(eventVM.getTimeToString(textDate: event.startTime)) ~ \(eventVM.getTimeToString(textDate: event.endTime))")
                    Image(systemName: "clock")
                        .font(.system(size: 15))
                }
                .font(.system(size: 13))
                .foregroundStyle(.neutral50)
            }
            .foregroundStyle(.neutral05)
            .frame(maxHeight: 40)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
        .padding(.bottom, 15)
    }
}
