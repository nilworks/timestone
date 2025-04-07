//
//  SearchLocationRowView.swift
//  timestone
//
//  Created by 이상민 on 3/26/25.
//

import SwiftUI

struct SearchLocationRowView: View {
    
    let document: Document
    
    var body: some View {
        VStack(alignment: .leading){
            Text(document.place_name)
                .font(.bodyMedium)
            
            if !document.road_address_name.isEmpty{
                Text(document.road_address_name)
                    .font(.captionLight)
                    .foregroundStyle(.neutral50)
            }else if !document.address_name.isEmpty{
                Text(document.address_name)
                    .font(.captionLight)
                    .foregroundStyle(.neutral50)
            }
        }//: VSTACK
        .foregroundStyle(.white)
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 60)
        .overlay(alignment: .top) {
            Divider()
        }
        .overlay(alignment: .bottom) {
            Divider()
        }
    }
}
