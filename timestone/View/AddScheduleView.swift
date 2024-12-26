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
        ScrollView {
            VStack {
                // 컨트롤러
                HStack {
                    // TODO: X버튼 기능 추가 필요
                    // X 아이콘 버튼
                    Button(action: {
                        
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // Save 버튼
                    // TODO: Save버튼 기능 추가 필요
                    Button(action: {
                        
                    }) {
                        Text("Save")
                            .font(.bodyRegular)
                            .foregroundColor(.netural60)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.top, 15)
                
                // 일정 제목 입력
                if #available(iOS 17.0, *) {
                    TextField("일정", text: $scheduleTitle, prompt: Text("일정").foregroundStyle(.netural70))
                        .font(.titleBold)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 40)
                        .foregroundColor(Color.white)
                } else {
                    TextField("일정", text: $scheduleTitle)
                        .font(.titleBold)
                        .padding([.leading, .trailing], 20)
                        .padding(.top, 40)
                        .foregroundColor(Color.white)
                }
                
                Divider()
                    .frame(height: 1.5) // 높이 값을 사용해서 Divider 두께 조절
                    .background(Color.netural80)
                
                // 알림
                HStack {
                    
                }
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.netural100))
    }
}

#Preview {
    TestView()
}
