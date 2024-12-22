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
    @State private var isShow = true
    
    var body: some View {
        VStack {
            Text("test")
                .font(.titleBold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.netural100))
    }
}

#Preview {
    TestView()
}
