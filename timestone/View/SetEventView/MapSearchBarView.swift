//
//  MapSearchBarView.swift
//  timestone
//
//  Created by 이상민 on 4/2/25.
//

import SwiftUI

struct MapSearchBarView: View {
    @EnvironmentObject private var viewModel: SearchLocationViewModel
    
    var body: some View {
        HStack{
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.neutral50)
            
            Text("위치 입력")
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
    MapSearchBarView()
}
