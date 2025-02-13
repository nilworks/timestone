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
        
        VStack {
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 1)) {
                ForEach(eventVM.getDailyEvents(), id: \.self) { event in
                    DailyCellView(event: event)
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(.red)
    }
}

struct DailyCellView: View {
    @EnvironmentObject var eventVM: EventViewModel
    
    var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
    var body: some View {
        Text(event.title ?? "nil")
    }
}

class EventViewModel: ObservableObject {
    let wholeEvents: [Event] = EventInfo().dummyEvents
    let dateFormatterManager = DateFormatManager.shared
    let calendar = Calendar.current
    
    @Published var day: Date = Date() {
        didSet {
            getDailyEvents()
        }
    }
    
    // value: -1(어제), 1(내일)
    func changeDay(value: Int) {
        if let newDay = calendar.date(byAdding: .day, value: value, to: day) {
            self.day = newDay
        }
    }
    
    // 일간 보기에서의 해당 날짜 Events 가져오기
    @discardableResult
    func getDailyEvents() -> [Event] {
        // YYYYMMdd
        let formattedDay: String = dateFormatterManager.basicDateString(date: day)
        
        let dailyEvents: [Event] = wholeEvents.filter {
            dateFormatterManager.formattedDateString(textDate: $0.startTime) == formattedDay || dateFormatterManager.formattedDateString(textDate: $0.endTime) == formattedDay
        }
        
        return dailyEvents
    }
}
