//
//  ShowCalendarView.swift
//  timestone
//
//  Created by 조성빈 on 12/20/24.
//

import SwiftUI

struct ShowCalendarView: View {
    @State var selectYearMonthBtn = "2024년 12월"
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Button {
                        // action
                    } label: {
                        Text(selectYearMonthBtn)
                            .font(.system(size: 27))
                            .fontWeight(.semibold)
                            .padding(.bottom)
                    }

                    Spacer()
                    
                    Button {
                        // action
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 24))
                    }

                }
                .padding(.horizontal, 20)
            }
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
                                .font(.system(size: 22))
                        }
                    })
                }
        }
    }
}

#Preview {
    ShowCalendarView()
}
