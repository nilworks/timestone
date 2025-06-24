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
    
    //MARK: - assets를 이용하여 이미지 썸네일 나오게 하기
    func loadThumbnail(asset: PHAsset, completion: @escaping (UIImage?) -> Void){
        let imageManager = PHImageManager.default()
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .fast
        options.deliveryMode = .highQualityFormat
        
        imageManager
            .requestImage(
                for: asset,
                targetSize: CGSize(width: 300, height: 300),
                contentMode: .aspectFill,
                options: options) { result, _ in
                    completion(result)
                }
    }
    
    //MARK: - 선택한 asset이 이미 선택되어있는지 / 아닌지 확인하여 업데이트 해주는 함수
    //viewmodel에서 currentIndex 처리할 필요없이 @escaping을 이용해서 View에서 처리할 수 있게하면 여러 뷰에서도 사용가능할 것 같다
    func preselectAssetUpdate(asset: PHAsset){
        //identifier 매개변수는 사용자가 선택한 asset의 identifier를 의미한다.
        let identifier = asset.localIdentifier
        
        //만약에 이미 선택되어 있는거면 해제를 하기 위해서 다시 누른 것이므로 배열에서 제거
        if let index = selectedAssetIDs.firstIndex(where: { $0 == identifier}){
            selectedAssetIDs.remove(at: index)
        }else{ //이미 선택되어 있는게 아니라면 선택됨으로 변경
            selectedAssetIDs.append(identifier)
        }
    }
    
    //MARK: - 제한된 접근에 사용할 이미지 추가 및 삭제하는 편집기 열기
    func presentLimitedImagePicker(){
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController,
              let presentedVC = rootViewController.presentedViewController else { return }
        
            PHPhotoLibrary.shared().presentLimitedLibraryPicker(from: presentedVC)
    }
}
