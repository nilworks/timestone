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
        config.selectionLimit = 10 // 최대 선택 가능 이미지 수
        
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
        
        func fetchImage(for assetID: String, completion: @escaping (UIImage?) -> Void) {
            let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetID], options: nil) // 에셋ID 사용해 사진앱에서 이미지 찾기
            
            guard let asset = fetchResult.firstObject else { // 이미지 찾으면 가져오기
                completion(nil) // 해당 ID의 이미지가 없을 경우 nil 반환
                return
            }

            let imageManager = PHImageManager.default() // 이미지 가져오는 도구를 변수에 담아 사용할 준비하기
            let options = PHImageRequestOptions()
            options.isSynchronous = false // 비동기적으로 이미지 요청
            
            // 위에서 준비한 도구 사용해서 이미지를 양식에 맞게 불러오기
            imageManager.requestImage(for: asset,
                                      targetSize: CGSize(width: 500, height: 500),
                                      contentMode: .aspectFit,
                                      options: options) { image, _ in
                completion(image)
            }
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.selectedImages.removeAll() // 선택된 이미지 초기화(미리보기 화면)
            parent.selectedAssetIDs = results.compactMap { $0.assetIdentifier }
            
            for assetID in parent.selectedAssetIDs {
                    fetchImage(for: assetID) { image in
                        if let image = image {
                            DispatchQueue.main.async {
                                self.parent.selectedImages.append(image) // 선택된 이미지 배열에 추가
                            }
                        }
                    }
                }

                print("Updated Asset IDs: \(parent.selectedAssetIDs)")
                picker.dismiss(animated: true) // 선택 후 picker 닫기
            }
    }
}



