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
    // MARK: -Properties
    @StateObject var viewModel = AddScheduleViewModel()
    @State private var scheduleTitle: String = ""
    @State private var clockIsOn: Bool = false
    @State private var selectDay = Date() // TODO: 캘린더에서 선택된 날짜 가져오도록 하기
    @State private var memoText: String = ""
    
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
                            .foregroundColor(.neutral60)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.top, 20)
                
                // 일정 제목 입력
                if #available(iOS 17.0, *) {
                    TextField("일정", text: $scheduleTitle, prompt: Text("일정").foregroundStyle(.neutral70))
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
                    .frame(height: 1.0) // 높이 값을 사용해서 Divider 두께 조절
                    .background(Color.neutral80)
                    .padding(.top, 5)
                
                // 알림
                HStack {
                    // 아이콘
                    VStack {
                        Image(systemName: "clock")
                            .font(.system(size: 18))
                            .foregroundColor(.primary100)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    // 알림, 시작, 종료
                    VStack(spacing: 15) {
                        // 알림
                        HStack {
                            Text("알림")
                                .font(.bodyRegular)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Toggle("", isOn: $clockIsOn)
                                .toggleStyle(ToggleSt())
                        }
                        
                        // 시작
                        HStack {
                            Text("시작")
                                .font(.bodyRegular)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            DatePicker("", selection: $selectDay)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                                .background()
                                .scaleEffect(0.8)
                                .offset(x: 30) // TODO: offset 말고 다른 방법 필요(핸드폰 사이즈에 따라 달라질 수 있음)
                        }
                        
                        // 종료
                        HStack {
                            Text("종료")
                                .font(.bodyRegular)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            DatePicker("", selection: $selectDay)
                                .environment(\.locale, Locale(identifier: "ko_KR"))
                                .scaleEffect(0.8)
                                .offset(x: 30)
                        }
                        .offset(y: -3)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.top, 20)
                
                Divider()
                    .frame(height: 1.0) // 높이 값을 사용해서 Divider 두께 조절
                    .background(Color.neutral80)
                    .padding(.top, 20)
                
                // 메모
                // 아이콘
                HStack {
                    VStack {
                        Image(systemName: "pencil")
                            .font(.system(size: 18))
                            .foregroundColor(.primary100)
                        Spacer()
                    }
                    .padding(.top, 2)
                    
                    Spacer()
                    
                    // 알림, 시작, 종료
                    HStack {
                        VStack {
                            Text("메모")
                            Spacer()
                        }
                        
                        Spacer()
                        
                        TextEditor(text: $memoText)
                            .font(.captionLight)
                            .frame(height: 96)
                            .cornerRadius(4)
                    }
                }
                .padding([.leading, .trailing], 20)
                .padding(.top, 20)
                
            } // VStack
        } // ScrollView
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.neutral100))
    }
}

#Preview {
    TestView()
}
