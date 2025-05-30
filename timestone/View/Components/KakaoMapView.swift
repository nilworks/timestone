//
//  KakaoMapView.swift
//  timestone
//
//  Created by 이상민 on 3/29/25.
//

import SwiftUI
import KakaoMapsSDK

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    @Binding var currentCoordinate: Coordinate //현재 위치
    @Binding var selectedCoordinate: SelectedCoordinate? //사용자가 선택한 위치
    @Binding var isActualCurrentLocation: Bool
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        //need to correct view size
        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        context.coordinator.createController(view)
        
        return view
    }
    
    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
                
                context.coordinator
                    .updateCamera(
                        to: selectedCoordinate?.coordinate ?? currentCoordinate)
                context.coordinator
                    .updatePois(
                        current: currentCoordinate,
                        selected: selectedCoordinate?.coordinate,
                        showCurrent: isActualCurrentLocation)
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        //선택된 위치가 있으면 해당 위치를 표시.
        //선택된 위치가 없으면 저장된 혹은 현재위치를 표시
        return KakaoMapCoordinator(
            coordinate: selectedCoordinate?.coordinate ?? currentCoordinate, showCurrent: isActualCurrentLocation
        )
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
        coordinator.controller?.delegate = nil
        coordinator.controller = nil
    }
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        init(coordinate: Coordinate, showCurrent: Bool) {
            first = true
            auth = false
            self.currentCoordinate = coordinate
            self.showCurrent = showCurrent
            super.init()
        }
        
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(
                longitude: currentCoordinate.longitude,
                latitude: currentCoordinate.latitude
            )
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition) //임시 좌표
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("OK")
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
            createLabelLayer()
            createPoiStyle()
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            updatePois(
                current: currentCoordinate,
                selected: nil,
                showCurrent: showCurrent
            )
            updateCamera(to: self.currentCoordinate)
        }
        
        func updateCamera(to coordinate: Coordinate){
            currentCoordinate = coordinate
            guard let mapView = controller?.getView("mapview") as? KakaoMap else{ return }
            let cameraUpdate = CameraUpdate.make(
                target: MapPoint(
                    longitude: coordinate.longitude,
                    latitude: coordinate.latitude
                ),
                mapView: mapView
            )
            mapView.moveCamera(cameraUpdate)
        }
        
        func authenticationSucceeded() {
            auth = true
            addViews()
        }
        
        //Poi생성을 위한 LabelLayer 생성
        // 1. 라벨 레이어 생성 + 성공 시 isLayerReady = true
        func createLabelLayer(){
            guard let mapView = controller?.getView("mapview") as? KakaoMap else {
                return
            }
            let manager = mapView.getLabelManager()
            let layerOption = LabelLayerOptions(
                layerID: "PoiLayer",
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 9999
            )
            let _ = manager.addLabelLayer(option: layerOption)
        }
        
        //Poi 표시 스타일 생성
        func createPoiStyle(){
            guard let mapView = controller?.getView("mapview") as? KakaoMap else { return }
            let manager = mapView.getLabelManager()
            //현재 위치 스타일
            
            let config = UIImage.SymbolConfiguration(
                pointSize: 15,
                weight: .regular,
                scale: .default)
            
            let currentSymbol = UIImage(
                systemName: "circle.fill",
                withConfiguration: config
            )?.withTintColor(.red, renderingMode: .alwaysOriginal)
            
            let currentIcon = PoiIconStyle(
                symbol: currentSymbol,
                anchorPoint: CGPoint(x: 0.5, y: 1.0)
            )
            let currentStyle = PoiStyle(styleID: "CurrentStyle", styles: [
                PerLevelPoiStyle(iconStyle: currentIcon)
            ])
            manager.addPoiStyle(currentStyle)
            
            let selectedSymbol = UIImage(
                systemName: "mappin.circle.fill",
                withConfiguration: config
            )?.withTintColor(.red, renderingMode: .alwaysOriginal)
            
            //선택된 위치 스타일
            let selectedIcon = PoiIconStyle(
                symbol: selectedSymbol,
                anchorPoint: CGPoint(x: 0.5, y: 1.0)
            )
            let selectedStyle = PoiStyle(styleID: "SelectedStyle", styles: [
                PerLevelPoiStyle(iconStyle: selectedIcon)
            ])
            manager.addPoiStyle(selectedStyle)
        }
        
        // 2. 업데이트 시에도 레이어 준비 상태 체크
        func updatePois(
            current: Coordinate,
            selected: Coordinate?,
            showCurrent: Bool
        ){
            guard let mapView = controller?.getView("mapview") as? KakaoMap else {
                return
            }
            let manager = mapView.getLabelManager()
            guard let layer = manager.getLabelLayer(layerID: "PoiLayer") else { return }
            
            layer.removePois(poiIDs: ["CurrentPoiID", "SelectedPoiID"])
            
            var options: [PoiOptions] = []
            var points: [MapPoint] = []
            
            if showCurrent{
                let currentOption = PoiOptions(styleID: "CurrentStyle", poiID: "CurrentPoiID")
                currentOption.rank = 100
                options.append(currentOption)
                points
                    .append(
                        MapPoint(
                            longitude: current.longitude,
                            latitude: current.latitude
                        )
                    )
            }
            
            if let sel = selected{
                let selectedOption = PoiOptions(
                    styleID: "SelectedStyle",
                    poiID: "SelectedPoiID"
                )
                selectedOption.rank = 101
                options.append(selectedOption)
                points
                    .append(
                        MapPoint(
                            longitude: sel.longitude,
                            latitude: sel.latitude
                        )
                    )
            }
            
            let pois = layer.addPois(options: options, at: points)
            pois?.forEach{$0.show()}
        }
        
        //속성 추가
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
        var currentCoordinate: Coordinate
        private var showCurrent: Bool
    }
}
