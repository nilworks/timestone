//
//  SearchLocationSheetView.swift
//  timestone
//
//  Created by 이상민 on 3/18/25.
//

import SwiftUI

struct SearchLocationSheetView: View {
    
    @StateObject private var viewModel: SearchLocationViewModel = SearchLocationViewModel()
    @State private var isSearching: Bool = false
    @State private var kakaoMapDraw: Bool = false
    
    var body: some View {
        ZStack{
            KakaoMapView(draw: $kakaoMapDraw)
            
            VStack{
                switch viewModel.viewState {
                case .idle:
                    MapSearchBarView()
                    Spacer()
                case .search:
                    LocationSearchView()
                }
            }
        }//: ZSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear(duration: 0.15), value: isSearching)
        .environmentObject(viewModel)
        .onAppear {
            kakaoMapDraw = true
        }
    }
}

#Preview {
    SearchLocationSheetView()
}
