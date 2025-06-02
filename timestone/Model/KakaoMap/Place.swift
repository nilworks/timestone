//
//  Place.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation

struct Place: Codable{
    let meta: Meta
    let documents: [Document]
}

struct Meta: Codable{
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
}

struct Document: Codable{
    let id: String
    let place_name: String
    let category_name: String
    let category_group_code: String
    let category_group_name: String
    let phone: String
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let place_url: String
    let distance: String
}

