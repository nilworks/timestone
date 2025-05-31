//
//  Coordinate.swift
//  timestone
//
//  Created by 이상민 on 4/3/25.
//

import Foundation

struct SelectedCoordinate{
    let placeName: String?
    let address: String
    let coordinate: Coordinate
}

struct Coordinate{
    let latitude: Double
    let longitude: Double
}
