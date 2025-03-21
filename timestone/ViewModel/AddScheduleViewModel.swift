//
//  AddScheduleViewModel.swift
//  timestone
//
//  Created by 김혜림 on 12/22/24.
//

import SwiftUI
import PhotosUI

class AddScheduleViewModel: ObservableObject {
    
}

// MARK: - 이미지 다중 선택을 위한 뷰모델
class ImagePickerViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = [] // 선택된 이미지를 저장하는 배열
    @Published var selectedAssetIDs: [String] = []
}
