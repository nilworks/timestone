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
    @Binding var selectedIdentifiers: [String]
    @Binding var selectedAssets: [PHAsset]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        let photoLibrary = PHPhotoLibrary.shared()
        var config = PHPickerConfiguration(photoLibrary: photoLibrary)

        config.filter = .images // 이미지 필터링
        config.selectionLimit = 10 // 최대 선택 가능 이미지 수
        config.preselectedAssetIdentifiers = Array(selectedIdentifiers) //사용자가 선택한 이미지 체크 표시
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
    }
    
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MultiImagePicker
        
        init(_ parent: MultiImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            updateSelectedAssets(results: results)
        }
        
        //MARK: - 사진 권한이 전체 허용일 때 선택한 사진을 저장하는 함수
        func updateSelectedAssets(results: [PHPickerResult]){
            let identifiers = results.compactMap(\.assetIdentifier)
            
            //새로 선택된 항목들에 대한 처리
            let newIdentifiers = identifiers.filter{ !parent.selectedIdentifiers.contains($0) }
            parent.selectedIdentifiers.append(contentsOf: newIdentifiers)
            
            //선택 해제된 항목들에 대한 처리
            let removedIdentifiers = parent.selectedIdentifiers.filter{ !identifiers.contains($0) }
            for identifier in removedIdentifiers {
                if let index = parent.selectedIdentifiers.firstIndex( of: identifier ){
                    parent.selectedIdentifiers.remove(at: index)
                }
            }
            
            let fetchResult = PHAsset.fetchAssets(
                withLocalIdentifiers: parent.selectedIdentifiers,
                options: nil
            )
            
            let indexSet = IndexSet(0..<fetchResult.count)
            let assets = fetchResult.objects(at: indexSet)
            
            parent.selectedAssets = assets
        }
    }
}



