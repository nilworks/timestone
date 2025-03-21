//
//  TextFieldCustom.swift
//  timestone
//
//  Created by 김혜림 on 12/22/24.
//

import SwiftUI


struct ToggleSt: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            RoundedRectangle(cornerRadius: 24 / 2)
                .fill(configuration.isOn ? Color.green : Color.neutral70)
                .frame(width: 46, height: 24)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 18, height: 18)
                        .offset(x: configuration.isOn ? 11 : -11)
                        .animation(.easeInOut, value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle() // 상태 변경
                }
        }
    }
}

