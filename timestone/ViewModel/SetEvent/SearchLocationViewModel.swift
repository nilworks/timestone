//
//  SearchLocationViewModel.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation
import CoreLocation

class SearchLocationViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    enum ViewState {
        case idle
        case search
    }
    
    @Published var searchLocationText: String = ""
    @Published var searchResultLocation: [Document] = []
    @Published var viewState: ViewState = .idle
    @Published var locationSettingAlert: Bool = false
    @Published var currentCoordinate: Coordinate?
    
    //MARK: - 위치 매니저 생성: 위치에 관련된 대부분을 담당
    lazy var locationManager = CLLocationManager()
    
    override init(){
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
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
            
            self.checkCurrentLocation()
        }
    }
    
    //MARK: - 현재 사용자의 위치 권한 상태 확인
    func checkCurrentLocation(){
        print(#function)
        let status = locationManager.authorizationStatus
        
        switch status{
        case .notDetermined:
            print("이 권환에서만 권환 문구 띄울 수 있음")
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            locationSettingAlert = true
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("오류 발생")
        }
    }
    
    //MARK: - 사용자의 권한상태가 변경될 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkDeviceLocation()
    }
    
    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.last else { return }
        let coordinate = Coordinate(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        
        DispatchQueue.main.async {
            self.currentCoordinate = coordinate
        }
        locationManager.stopUpdatingLocation()
    }
    
    //MARK: - 사용자의 위치를 성공적으로 가지고 오지 못한 경우
    //ex) 사용자가 허용 안함 / 자녀 보호 기능
    func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: any Error
    ) {
        print(error.localizedDescription)
    }
}
