//
//  ReverseGeocodingResponse.swift
//  timestone
//
//  Created by 이상민 on 4/8/25.
//

import Foundation

struct ReverseGeocodingResponse: Codable{
    let meta: ReverseMeta
    let documents: [AddressDocument]
}

struct ReverseMeta: Codable{
    let total_count: Int
}

struct AddressDocument: Codable{
    let address: Address
    let road_address: RoadAddress
}

struct Address: Codable{
    let address_name: String
    let region_1depth_name: String
    let region_2depth_name: String
    let region_3depth_name: String
    let mountain_yn: String
    let main_address_no: String
    let sub_address_no: String
}

struct RoadAddress: Codable{
    let address_name: String //전체 도로명 주소
    let region_1depth_name: String //지역 1Depth, 시도 단위
    let region_2depth_name: String //지역 2Depth, 구 단위
    let region_3depth_name: String //지역 3Depth, 면 단위
    let road_name: String //도로명
    let underground_yn: String //지하 여부, Y || N
    let main_building_no: String //건물 본번
    let sub_building_no: String //건물 부번, 없을 경우 빈 문자열("")반환
    let building_name: String //건물 이름
    let zone_no: String //우편번호(5자리)
}
