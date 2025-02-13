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
            .padding(.top, 30)
            Spacer()
        }
        .frame(maxHeight: .infinity)
    }
}

struct DailyCellView: View {
    @EnvironmentObject var eventVM: EventViewModel
    
    var event: Event
    
    init(event: Event) {
        self.event = event
    }
    
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
    
    func resetDay() {
        self.day = Date()
    }
    
    // 일간 보기에서의 해당 날짜 Events 가져오기
    @discardableResult
    func getDailyEvents() -> [Event] {
        // YYYYMMdd
        let formattedDay: String = dateFormatterManager.basicDateString(date: day)
        
        let dailyEvents: [Event] = wholeEvents.filter {
            dateFormatterManager.removeHypenDateString(textDate: $0.startTime) == formattedDay || dateFormatterManager.removeHypenDateString(textDate: $0.endTime) == formattedDay
        }
        
        return dailyEvents
    }
    
    // [String] date to time(DateFormatManager 싱글톤 함수 사용)
    func getTimeToString(textDate: String) -> String {
        return dateFormatterManager.timeToString(textDate: textDate)
    }
    
    // MM월 dd일 EEEE : dailyView의 title
    func dailyViewTitle() -> String {
        return dateFormatterManager.dailyViewTitleFormat(date: day)
    }
}
