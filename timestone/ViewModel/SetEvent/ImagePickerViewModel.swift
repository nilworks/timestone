//
//  ImagePickerViewModel.swift
//  timestone
//
//  Created by 이상민 on 6/22/25.
//

import PhotosUI

// MARK: - 이미지 다중 선택을 위한 뷰모델
class ImagePickerViewModel: ObservableObject {
    @Published var showAllAlbum: Bool = false //사진 권한이 전체허용 변수
    @Published var showLimitedAlbum: Bool = false //사진 권한이 제한된 접근 변수
    @Published var showDeniedAlert: Bool = false //사진 권한이 거부일 때 alert 요철 변수
    @Published var selectedImages: [UIImage] = [] // 선택된 이미지를 저장하는 배열
    @Published var selectedAssetIDs: [String] = [] //선택된 이미지들의 Identifier를 저장하는 배열
    
    //MARK: - 권한 요청 함수
    func checkPHotoLibraryPermission(){
        let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
        
        switch status{
        case .notDetermined: //권한설정을 하지 않았을 떄
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { [weak self] status in
                DispatchQueue.main.async {
                    if status == .authorized{ //전체 허용을 선택했을 때
                        self?.showAllAlbum = true
                    }else if status == .limited{ //제한된 접근을 선택했을 때
                        self?.showLimitedAlbum = true
                    }else{ //허용안함을 선택했을 때
                        self?.showDeniedAlert = true
                    }
                }
            }
        case .restricted, .denied: //권한설정이 허용안함으로 되어있을 때
            DispatchQueue.main.async {
                self.showDeniedAlert = true
            }
        case .authorized: //권한설정이 전체허용으로 되어있을 때
            DispatchQueue.main.async {
                self.showAllAlbum = true
            }
        case .limited: //권한설정이 제한된 접근으로 되어있을 때
            DispatchQueue.main.async {
                self.showLimitedAlbum = true
            }
        @unknown default:
            print("새로운 권한 상태가 추가되었습니다.")
        }
    }
}
