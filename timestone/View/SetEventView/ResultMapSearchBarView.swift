//
//  ResultMapSearchBarView.swift
//  timestone
//
//  Created by 이상민 on 4/8/25.
//

import SwiftUI

struct ResultMapSearchBarView: View {
    @EnvironmentObject private var viewModel: SearchLocationViewModel
    
    var body: some View {
        HStack{
            Button {
                viewModel.viewState = .search
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.neutral50)
            }
            
            Text("여기는 장소 이름")
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
        }//: HSTACK
        .modifier(SearchBarStyle())
        .onTapGesture {
            viewModel.viewState = .search
        }
    }
}

#Preview {
    ResultMapSearchBarView()
}
