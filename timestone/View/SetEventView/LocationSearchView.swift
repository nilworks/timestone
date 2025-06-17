//
//  LocationSearchView.swift
//  timestone
//
//  Created by 이상민 on 4/2/25.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject private var viewModel: SearchLocationViewModel
    @FocusState private var searchTextFocusState: Bool
    var body: some View {
        VStack{
            HStack{
                Button {
                    viewModel.viewState = .idle
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.neutral50)
                }
                
                
                TextField("위치 입력", text: $viewModel.searchLocationText)
                    .foregroundStyle(.white)
                    .onChange(of: viewModel.searchLocationText) { newValue in
                        viewModel.fetchSearchLocation()
                    }
                    .onSubmit {
                        if viewModel.currentStatus == .connected{
                            viewModel.fetchSearchLocation()
                        }else{
                            viewModel.showNoSearchResultView = true
                        }
                    }
                    .focused($searchTextFocusState)
                    .keyboardType(.webSearch)
                
                if !viewModel.searchLocationText.isEmpty{
                    Button {
                        viewModel.searchLocationText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.neutral50)
                    }
                    
                }
            }//: HSTACK
            .modifier(SearchBarStyle())
            .background(.neutral90)
            
            if !viewModel.showNoSearchResultView{
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                        Section{
                            ForEach(viewModel.searchResultLocation, id: \.id){ document in
                                Button {
                                    viewModel
                                        .updateCurrentCoordinate(
                                            placeName: document.place_name, address: document.road_address_name.isEmpty ? document.address_name : document.road_address_name,
                                            document.y,
                                            document.x)
                                    viewModel.viewState = .result
                                } label: {
                                    SearchLocationRowView(document: document)
                                }
                                .overlay(alignment: .top) {
                                    Divider()
                                }
                                .overlay(alignment: .bottom) {
                                    Divider()
                                }
                            }//: LOOP
                        } header: {
                            Text("지도 위치")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(.neutral90)
                                .padding(.bottom, 5)
                        }//: SECTION
                        .padding(.leading, 15)
                    }//: LazyVStack
                }//: SCROLLVIEW
            }else{
                Text("검색 결과가 없습니다.")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding(.top, 30)
            }
            
            Spacer()
        }//: VSTACK
        .background(.neutral90)
        .onAppear{
            self.searchTextFocusState = true
        }
    }
}

#Preview {
    LocationSearchView()
}
