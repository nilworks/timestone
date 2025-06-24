//
//  PhotoThumbnailView.swift
//  timestone
//
//  Created by 이상민 on 6/22/25.
//

import SwiftUI
import PhotosUI

struct PhotoThumbnailView: View {
    let asset: PHAsset
    let dimension: CGFloat
    
    @State private var image: UIImage? = nil
    @EnvironmentObject private var imagePickerViewModel: ImagePickerViewModel
    
    var body: some View {
        if let image = image{
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
                .frame(width: dimension, height: dimension)
                .clipped()
        }else{
            Rectangle()
                .fill(Color.gray)
                .frame(width: dimension, height: dimension)
                .onAppear {
                    imagePickerViewModel.loadThumbnail(asset: asset) { result in
                        self.image = result
                    }
                }
        }
    }
}
