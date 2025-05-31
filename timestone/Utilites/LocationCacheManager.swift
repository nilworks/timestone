//
//  LocationCacheManager.swift
//  timestone
//
//  Created by 이상민 on 4/14/25.
//

import Foundation

final class LocationCacheManager{
    static let shared = LocationCacheManager()
    private init(){ }
    
    private let defaults = UserDefaults.standard
    
    private enum keys{
        static let latitude = "lastLatitude"
        static let longitude = "lastLongitude"
    }
    
    func save(coordinate: Coordinate){
        defaults.setValue(coordinate.latitude, forKey: keys.latitude)
        defaults.setValue(coordinate.longitude, forKey: keys.longitude)
    }
    
    func load() -> SelectedCoordinate{
        let defaultCoordinate = Coordinate(latitude: 37.402001, longitude: 127.108678) //카카오 본사
        
        guard let latitude = defaults.value(forKey: keys.latitude) as? Double,
              let longitude = defaults.value(forKey: keys.longitude) as? Double else{
            let defaultCoordinate = SelectedCoordinate(placeName: nil, address: "", coordinate: defaultCoordinate)
            return defaultCoordinate
        }
        
        let currentCoordinate = SelectedCoordinate(placeName: nil, address: "", coordinate: Coordinate(latitude: latitude, longitude: longitude))
        return currentCoordinate
    }
}
