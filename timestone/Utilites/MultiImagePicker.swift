//
//  MultiImagePicker.swift
//  timestone
//
//  Created by 김혜림 on 1/9/25.
//

import SwiftUI
import PhotosUI
import Photos

struct MultiImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [UIImage] // 선택된 이미지 배열
    @Binding var selectedAssetIDs: [String] // 선택된 이미지 ID 배열
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)

        config.filter = .images // 이미지 필터링
        config.selectionLimit = 5 // 최대 선택 가능 이미지 수
        
        // 이전에 선택된 에셋 ID를 preselectedAssetIdentifiers에 설정
        config.preselectedAssetIdentifiers = selectedAssetIDs
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultiImagePicker
        
        init(_ parent: MultiImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll() // 선택된 이미지 초기화(미리보기 화면)
            // parent.selectedAssetIDs.removeAll() // 선택된 ID 초기화
            
            for result in results {
                
                if let assetID = result.assetIdentifier {
                    parent.selectedAssetIDs.append(assetID) // 선택된 에셋 ID 배열에 추가
                } else {
                    print("Asset ID is nil")
                }
                
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] object, error in
                        if let image = object as? UIImage {
                            DispatchQueue.main.async {
                                self?.parent.selectedImages.append(image) // 이미지 배열에 추가
                            }
                        }
                    }
                }
            }
            print("Selected Asset ID: \(parent.selectedAssetIDs)")
            picker.dismiss(animated: true) // 선택 후 picker 닫기
        }
    }
}



