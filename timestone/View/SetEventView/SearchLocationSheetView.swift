//
//  SearchLocationSheetView.swift
//  timestone
//
//  Created by 이상민 on 3/18/25.
//

import SwiftUI

struct SearchLocationSheetView: View {
    
    @State private var searchLocationText: String = ""
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.neutral50)
                
                TextField("위치 입력", text: $searchLocationText)
                    .foregroundStyle(.white)
                
                if !searchLocationText.isEmpty{
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .frame(height: 50)
                        .overlay(alignment: .top) {
                            Divider()
                        }
                        .overlay(alignment: .bottom) {
                            Divider()
                        }
                    }//: SECTION
                    .padding([.leading, .bottom], 15)
                    
                    Section{
                        ForEach(1..<100){_ in
                            HStack{
                                Image(systemName: "paperplane.circle.fill")
                                Text("현재 위치")
                            }//: HSTACK
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .frame(height: 50)
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
