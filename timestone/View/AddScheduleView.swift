//
//  AddScheduleView.swift
//  timestone
//
//  Created by 김혜림 on 12/22/24.
//

import SwiftUI

struct TestView: View {
    @State private var isShow = true
    
    var body: some View {
        VStack {
            Button("show") {
                isShow.toggle()
            }
        }
        .sheet(isPresented: $isShow) {
            AddScheduleView()
        }
    }
}

struct AddScheduleView: View {
    @StateObject var viewModel = AddScheduleViewModel()
    @State private var scheduleTitle: String = ""
    
    var body: some View {
        VStack {
            if #available(iOS 17.0, *) {
                TextField("일정", text: $scheduleTitle, prompt: Text("일정").foregroundStyle(.netural70))
                    .font(.titleBold)
                    .padding(20)
                    .foregroundColor(Color.white)
            } else {
                TextField("일정", text: $scheduleTitle)
                    .font(.titleBold)
                    .padding(20)
                    .foregroundColor(Color.white)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.netural100))
    }
}

#Preview {
    TestView()
}
