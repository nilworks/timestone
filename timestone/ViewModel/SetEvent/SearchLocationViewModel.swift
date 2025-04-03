//
//  SearchLocationViewModel.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation
import CoreLocation

class SearchLocationViewModel: ObservableObject{
    enum ViewState {
        case idle
        case search
    }
    
    @Published var searchLocationText: String = ""
    @Published var searchResultLocation: [Document] = []
    @Published var viewState: ViewState = .idle
    @Published var locationSettingAlert: Bool = false
    
    //MARK: - 위치 매니저 생성: 위치에 관련된 대부분을 담당
    private let locationManager = CLLocationManager()
    
    @MainActor
    func fetchSearchLocation(){
        Task{
            do{
                let response: Place = try await NetworkManager.shared
                    .CallbackRequest(
                        request: KakaoRequest
                            .placeSearch(query: self.searchLocationText)
                    )
                searchResultLocation = response.documents
            }catch{
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: - 기기의 위치 서비스 -> 허용
    func checkDeviceLocation(){
        print(#function)
        Task.detached { [weak self] in
            guard let self = self else { return }
            guard CLLocationManager.locationServicesEnabled() else{
                await MainActor.run {
                    self.locationSettingAlert = true
                }
                return
            }
            
            // TODO: 앱에서 위치 권한 확인
        }
    }
}
