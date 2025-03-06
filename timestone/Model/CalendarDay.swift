//
//  CalendarDay.swift
//  timestone
//
//  Created by 조성빈 on 3/6/25.
//

import SwiftUI

struct CalendarDay: Hashable {
    let date: Date
    let dayOfWeek: String
    let isCurrentMonth: Bool
}
