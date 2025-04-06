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
    @Binding var coordinate: Coordinate
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
                
                context.coordinator.updateCamera(to: coordinate)
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(coordinate: coordinate)
    }
    
    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
        coordinator.controller?.delegate = nil
        coordinator.controller = nil
    }
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        init(coordinate: Coordinate) {
            first = true
            auth = false
            self.currentCoordinate = coordinate
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
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
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
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
        var currentCoordinate: Coordinate
    }
}
