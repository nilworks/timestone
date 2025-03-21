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
            
            Divider()
                .padding(.vertical, 10)
                .background(.red)
            
            List{
                Section{
                    Text("안녕하시렵니까?>")
                }
                .background(.green)
                
                Section("지도 위치") {
                    LazyVStack(
                        alignment: .leading,
                        spacing: 10,
                        pinnedViews: .sectionHeaders) {
                            ForEach(1..<100){_ in
                                HStack{
                                    Image(systemName: "paperplane.circle.fill")
                                    Text("현재 위치")
                                }//: HSTACK
                                .frame(height: 40)
                            }//: LOOP
                        }//: LazyVStack
                }//: SECTION
                .background(.green)
            }//: LIST
            .background(.orange)
            
            Spacer()
        }//: VSTACK
        .background(.neutral90)
        .navigationTitle("위치")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchLocationSheetView()
}
