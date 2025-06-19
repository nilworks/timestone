//
//  CustomDatePicker.swift
//  timestone
//
//  Created by 김혜림 on 2/7/25.
//

import SwiftUI

// CustomDatePickerButton
struct CustomDatePickerButton: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    @State private var showDatePicker = false
    @State var showTimePicker = false
    @State var dateButtonPosition: CGPoint = .zero
    @State var timeButtonPosition: CGPoint = .zero
    @Binding var selectedButtonPosition: CGPoint

    
    var body: some View {
        HStack {
            GeometryReader { geometry in
                Button(action: {
                    viewModel.showDatePicker.toggle()
                    viewModel.showTimePicker = false
                    selectedButtonPosition = dateButtonPosition
                }) {
                    Text(viewModel.formattedDate())
                        .font(.captionLight)
                        .foregroundStyle(.white)
                }
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
                .background(.neutral80)
                .cornerRadius(4)
                .onAppear {
                    // 버튼의 좌표와 크기를 얻어옴
                    self.dateButtonPosition = geometry.frame(in: .global).origin
                }
            }
            .frame(width: 100 ,height: 25)
            
            GeometryReader { geometry in
                Button(action: {
                    viewModel.showTimePicker.toggle()
                    viewModel.showDatePicker = false
                    selectedButtonPosition = timeButtonPosition
                }) {
                    Text(viewModel.formattedTime())
                        .font(.captionLight)
                        .foregroundStyle(.white)
                }
                .padding([.leading, .trailing], 8)
                .padding([.top, .bottom], 4)
                .background(.neutral80)
                .cornerRadius(4)
                .onAppear {
                    // 버튼의 좌표와 크기를 얻어옴
                    self.timeButtonPosition = geometry.frame(in: .global).origin
                }
            }
            .frame(width: 100 ,height: 25)
            .padding(.trailing, -18)
        }
    }
}

// CustomDatePickerPopUp
struct CustomDatePickerPopUp: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    @Binding var selectedButtonPosition: CGPoint
    
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
            .position(x: selectedButtonPosition.x + 40, y: selectedButtonPosition.y + 145)  // Binding된 위치 사용
    }
}


// DatePicker PopUpView
struct CustomTimePickerPopUp: View {
    @ObservedObject var viewModel: CustomDatePickerViewModel
    @Binding var selectedButtonPosition: CGPoint
    
    var body: some View {
        // 팝업 창
        DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.hourAndMinute])
            .environment(\.locale, Locale(identifier: "ko_KR"))
            .datePickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: 250)
            .background(.neutral80)
            .cornerRadius(15)
            .shadow(color: .neutral90, radius: 10)
            .position(x: selectedButtonPosition.x - 43 , y: selectedButtonPosition.y + 145)
    }
}


