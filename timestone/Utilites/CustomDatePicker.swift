//
//  CustomDatePicker.swift
//  timestone
//
//  Created by 김혜림 on 2/7/25.
//

import SwiftUI

// DatePicker ButtonView
struct CustomDatePickerButton: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    @State private var showDatePicker = false
    @State var showTimePicker = false
    
    var body: some View {
        // 날짜 선택
        Button(action: {
            viewModel.showDatePicker.toggle()
            viewModel.showTimePicker = false
        }) {
            Text(viewModel.formattedDate())
                .font(.captionLight)
                .foregroundStyle(.white)
            
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        .background(.neutral80)
        .cornerRadius(4)
        
        // 시간 선택
        Button(action: {
            viewModel.showTimePicker.toggle()
            viewModel.showDatePicker = false
        }) {
            Text(viewModel.formattedTime())
                .font(.captionLight)
                .foregroundStyle(.white)
            
        }
        .padding([.leading, .trailing], 8)
        .padding([.top, .bottom], 4)
        .background(.neutral80)
        .cornerRadius(4)
    }
    
}

// DatePicker PopUpView
struct CustomDatePickerPopUp: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    
    var body: some View {
        // 팝업 창
        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.date])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: 300)
            .background(.neutral80)
            .cornerRadius(15)
            .shadow(color: .neutral90, radius: 10)
    }
}

// DatePicker PopUpView
struct CustomTimePickerPopUp: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    
    var body: some View {
        // 팝업 창
        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: 250)
            .background(.neutral80)
            .cornerRadius(15)
            .shadow(color: .neutral90, radius: 1)
    }
}


