//
//  ContentView.swift
//  timestone
//
//  Created by 이상민 on 12/19/24.
//

import SwiftUI



struct ContentView: View {

    var body: some View {
        TabView {
            ShowCalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("일정")
                }
            // 맞는 View로 바꿔서 적용하시면 됩니다.
            DetailEventView()
                .tabItem {
                    Image(systemName: "plus.square")
                    Text("디테일 뷰")
                }
            // 맞는 View로 바꿔서 적용하시면 됩니다.
            ShowCalendarView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("설정")
                }
        }
    }
    
}

#Preview {
    ContentView()
}
