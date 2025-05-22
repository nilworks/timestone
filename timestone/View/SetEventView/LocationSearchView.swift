//
//  LocationSearchView.swift
//  timestone
//
//  Created by 이상민 on 4/2/25.
//

import SwiftUI

struct LocationSearchView: View {
    @EnvironmentObject private var viewModel: SearchLocationViewModel
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
            
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                    Section{
                        Button {
                            viewModel.checkDeviceLocation()
                            viewModel.viewState = .result
                        } label: {
                            HStack{
                                Image(systemName: "paperplane.circle.fill")
                                Text("현재 위치")
                            }//: HSTACK
                        }
                        .font(.bodyMedium)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 60)
                        .overlay(alignment: .top) {
                            Divider()
                        }
                        .overlay(alignment: .bottom) {
                            Divider()
                        }
                    }//: SECTION
                    .padding(.leading, 15)
                    .padding(.bottom, 30)
                    
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
        }//: VSTACK
        .background(.neutral90)
    }
}

#Preview {
    LocationSearchView()
}
