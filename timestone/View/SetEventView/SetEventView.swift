//
//  SetEventView.swift
//  timestone
//
//  Created by Jude Song on 12/21/24.
//

import SwiftUI

struct SetEventView: View {
    
    @State var inputLink: String = ""
    @State var addLocation: String = ""
    
    var body: some View {
        HStack {
            Image(systemName: "link")
                .foregroundStyle(.primary100)
                .padding(.trailing, 10)
            Text("링크")
                .foregroundStyle(.white)
                .font(.bodyRegular)
                .padding(.trailing, 30)
            TextField(
                "링크를 입력해 주세요.",
                text: $inputLink,
                prompt: Text("링크를 입력해 주세요.")
                    .foregroundColor(.neutral50)
                )
            .padding(10)
            .foregroundStyle(.white)
            .font(.captionLight)
            .frame(width: 260, height: 21, alignment: .leading)
            .background(.neutral80)
            .cornerRadius(4)//추후 코드 수정 필요

        }
        HStack {
            Image(systemName: "map")
            Text("장소")
            TextField("위치를 입력해 주세요.", text: $addLocation)
            //sourcetree 테스트용 주석
        }
        
    }
}

#Preview {
    SetEventView()
}
