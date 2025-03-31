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
                HStack{
                    if isSearching{
                        Button {
                            isSearching = false
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundStyle(.neutral50)
                        }
                        
                    }else{
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.neutral50)
                    }
                    
                    TextField("위치 입력", text: $viewModel.searchLocationText)
                        .foregroundStyle(.white)
                        .onChange(of: viewModel.searchLocationText) { newValue in
                            viewModel.fetchSearchLocation()
                        }
                    
                    if !viewModel.searchLocationText.isEmpty{
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.neutral50)
                    }
                }//: HSTACK
                .font(.subBodyRegular)
                .padding(10)
                .background(.neutral80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.horizontal, 15)
                .onTapGesture {
                    isSearching = true
                }
                
                if isSearching{
                    ScrollView(.vertical) {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: .sectionHeaders) {
                            Section{
                                HStack{
                                    Image(systemName: "paperplane.circle.fill")
                                    Text("현재 위치")
                                }//: HSTACK
                                .font(.bodyMedium)
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
                                    SearchLocationRowView(document: document)
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
                    Spacer()
                }
            }
        }//: ZSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
        .animation(.linear(duration: 0.15), value: isSearching)
        .onAppear {
            kakaoMapDraw = true
        }
    }
}

#Preview {
    SearchLocationSheetView()
}
