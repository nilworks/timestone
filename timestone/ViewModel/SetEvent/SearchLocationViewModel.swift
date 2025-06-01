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
        case result
    }
    
    @Published var searchLocationText: String = ""
    @Published var searchResultLocation: [Document] = []
    @Published var viewState: ViewState = .idle
    @Published var locationSettingAlert: Bool = false
    @Published var currentCoordinate: SelectedCoordinate = LocationCacheManager.shared.load() //사용자의 현재 위치(최초는 캐시에 저장된 위치 불러오기)
    @Published var selectedCoordinate: SelectedCoordinate? = nil//선택된(검색한) 위치 정보 -> 사용자가 검색한 장소의 poi를 보여주기 위한 용도
    @Published var isActualLocation: Bool = false //실제 현재 위치인지 검증하는 프로퍼티(캐시에 저장되어 있는 값을 가져온 경우는 false)
    @Published var setCoordinate: SelectedCoordinate? = nil
    var allowAuthorization: Bool = false
    @Published var isSelectedCurrentLocationBtn: Bool = false
    
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
    
    @MainActor
    func fetchReverseGeocoding(longitude: String, latitude: String){
        Task{
            do{
                guard let doubleLongitude = Double(longitude), let doubleLatitude = Double(latitude) else { return }
                
                let response: ReverseGeocodingResponse = try await NetworkManager.shared.CallbackRequest(
                    request: KakaoRequest
                        .reverseGeocoding(longitude: longitude,
                                          latitude: latitude
                                         )
                )
                guard let currentPosition = response.documents.first else { return }
                
                let selectedPosition = SelectedCoordinate(
                    placeName: currentPosition.road_address?.building_name,
                    address: currentPosition.road_address?.address_name ?? currentPosition.address.address_name,
                    coordinate: Coordinate(
                        latitude: doubleLatitude,
                        longitude: doubleLongitude)
                )
                
                self.currentCoordinate = selectedPosition
                LocationCacheManager.shared.save(coordinate: Coordinate(latitude: doubleLatitude, longitude: doubleLongitude))
                self.isActualLocation = true
                
                //현재 위치 아이콘 버튼을 클릭했지만 권한이 꺼져있다면 이동하면 안됨.
                if isSelectedCurrentLocationBtn{
                    self.setCoordinate = selectedPosition
                    self.isSelectedCurrentLocationBtn = false
                    viewState = .result
                }
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
                    self.isSelectedCurrentLocationBtn = false
                }
                return
            }
            
            self.checkCurrentLocation()
        }
    }
    
    //MARK: - 현재 사용자의 위치 권한 상태 확인
    func checkCurrentLocation(){
        let status = locationManager.authorizationStatus
        
        switch status{
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            DispatchQueue.main.async {
                self.locationSettingAlert = true
                self.isSelectedCurrentLocationBtn = false
            }
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        @unknown default:
            print("오류 발생")
        }
    }
    
    //MARK: - 사용자의 권한상태가 변경될 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard allowAuthorization else {
            print("권한 요청이 차단됨(아직 허용 안 됨)")
            return
        }
        
        checkDeviceLocation()
        
        let status = manager.authorizationStatus
        if status == .denied || status == .restricted{
            DispatchQueue.main.async {
                self.isActualLocation = false
            }
        }
    }
    
    func startLocationFlw(){
        if setCoordinate == nil{
            viewState = .idle
        }else{
            viewState = .result
        }
        self.allowAuthorization = true
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
        
        DispatchQueue.main.async{
            self.fetchReverseGeocoding(
                longitude: String(coordinate.longitude),
                latitude: String(coordinate.latitude)
            )
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
        DispatchQueue.main.async {
            self.isActualLocation = false
        }
    }
    
    //MARK: - 검색 결과 자표로 위치 업데이트 함수
    func updateCurrentCoordinate(placeName: String, address: String, _ y: String, _ x: String){
        if let latitude = Double(y), let longitude = Double(x) {
            selectedCoordinate = SelectedCoordinate(
                placeName: placeName,
                address: address,
                coordinate: Coordinate(latitude: latitude, longitude: longitude)
            )
            
            setCoordinate = selectedCoordinate
        }else{
            print("좌표 변환 실페: latitude=\(y), longitude=\(x)")
        }
        viewState = .idle
    }
}
