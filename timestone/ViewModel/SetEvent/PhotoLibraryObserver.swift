//
//  PhotoLibraryObserver.swift
//  timestone
//
//  Created by 이상민 on 6/22/25.
//

import PhotosUI

class PhotoLibraryObserver: NSObject, PHPhotoLibraryChangeObserver, ObservableObject{
    @Published var assets: [PHAsset] = []
    private var fetchResult: PHFetchResult<PHAsset>?
    
    override init(){
        super.init()
        PHPhotoLibrary.shared().register(self) //ChangeObserver 등록
        loadInitialAssets()
    }
    
    deinit{
        PHPhotoLibrary.shared().unregisterChangeObserver(self) //등록 해제
    }
    
    //MARK: - 초기 데이터 코드
    private func loadInitialAssets(){
        //PHFetchOpions는 데이터를 가져올 때 사용할 정렬 조건 및 필터링 조건을 설정하는 객체
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        updateAssets()
    }
    
    //MARK: - FetchResult를 기반으로 자산 업데이트
    private func updateAssets(){
        guard let fetchResult = fetchResult else { return }
        //앱에서 사용할 수 있는 형태 변환
        self.assets = fetchResult.objects(at: IndexSet(0..<fetchResult.count))
    }
    
    //MARK: - 앨범의 변화를 감지했을 때 실행되는 delegate 함수
    func photoLibraryDidChange(_ changeInstance: PHChange) {
        DispatchQueue.main.async {
            if let change = changeInstance.changeDetails(for: self.fetchResult!){
                self.fetchResult = change.fetchResultAfterChanges
                self.updateAssets()
            }
        }
    }
}
