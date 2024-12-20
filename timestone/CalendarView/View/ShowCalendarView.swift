//
//  ShowCalendarView.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct ShowCalendarView: View {
    
    var body: some View {
        NavigationView {
            Text("hi2")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button {
                            // action
                        } label: {
                            Image("CalendarIcon")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .background(.red)
                        }
                    })
                    ToolbarItem(placement: .topBarTrailing, content: {
                        Button {
                            // action
                        } label: {
                            Image(systemName: "bell")
                                .font(.system(size: 21))
                        }
                    })
                }
        }
    }
}

#Preview {
    ShowCalendarView()
}
