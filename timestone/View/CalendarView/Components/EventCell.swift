//
//  EventCell.swift
//  timestone
//
//  Created by 조성빈 on 2/13/25.
//

import SwiftUI

struct EventCell: View {
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
                        MarqueeText(text: "\(moreEvent != 0 ? (moreEvent > 999 ? "+999" : "+\(moreEvent)") : event.title ?? "nil")")
                            .font(.system(size: 13))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                    }
            }
        }
    }
}

