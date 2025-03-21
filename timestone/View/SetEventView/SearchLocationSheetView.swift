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
            
            List{
                Section{
                    HStack{
                        Image(systemName: "paperplane.circle.fill")
                        Text("현재 위치")
                    }//: HSTACK
                    .alignmentGuide(.listRowSeparatorLeading) { dimension in
                        dimension[.leading]
                    }
                }
                
                Section("지도 위치") {
                    ForEach(1..<100){_ in
                        HStack{
                            Image(systemName: "paperplane.circle.fill")
                            Text("현재 위치")
                        }//: HSTACK
                        .alignmentGuide(.listRowSeparatorLeading) { dimension in
                            dimension[.leading]
                        }
                    }//: LOOP
                }//: SECTION
            }//: LIST
            .listStyle(.plain)
        }//: VSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchLocationSheetView()
}
