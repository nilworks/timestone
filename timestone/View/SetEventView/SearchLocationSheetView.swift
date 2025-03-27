//
//  SearchLocationSheetView.swift
//  timestone
//
//  Created by 이상민 on 3/18/25.
//

import SwiftUI

struct SearchLocationSheetView: View {
    
    @StateObject private var viewModel: SearchLocationViewModel = SearchLocationViewModel()
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.neutral50)
                
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
                    .padding([.leading, .bottom], 15)
                    
                    Section{
                        ForEach(viewModel.searchResultLocation, id: \.id){ document in
                            SearchLocationRowView(document: document)
                        }//: LOOP
                    } header: {
                        Text("지도 위치")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(.neutral90)
                            .padding(.bottom, 15)
                    }//: SECTION
                    .padding(.leading, 15)
                }//: LazyVStack
            }//: SCROLLVIEW
        }//: VSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchLocationSheetView()
}
