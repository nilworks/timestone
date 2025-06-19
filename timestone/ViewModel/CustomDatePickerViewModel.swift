//
//  CustomDatePickerViewModel.swift
//  timestone
//
//  Created by 김혜림 on 2/7/25.
//

import SwiftUI

class CustomDatePickerViewModel: ObservableObject {
    @Published var selectedDate: Date = Date()
    @Published var showDatePicker: Bool = false
    @Published var showTimePicker: Bool = false
    
    // 날짜 반환 형식 지정
    func formattedDate() -> String {
        let formatterDate = DateFormatter()
        
        formatterDate.dateFormat = "yyyy. MM. dd"
        
        return formatterDate.string(from: selectedDate)
    }
    
    func formattedTime() -> String {
        let formatterTime = DateFormatter()
        formatterTime.dateFormat = "a hh:mm"
        formatterTime.locale = Locale(identifier: "ko_KR")
        
        return formatterTime.string(from: selectedDate)
    }
}
