//
//  SearchBarStyle.swift
//  timestone
//
//  Created by 이상민 on 4/2/25.
//

import SwiftUI

struct SearchBarStyle: ViewModifier {
    func body(content: Content) -> some View{
        content
            .font(.subBodyRegular)
            .padding(10)
            .background(.neutral80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 15)
            .padding(.top, 15)
    }
}
