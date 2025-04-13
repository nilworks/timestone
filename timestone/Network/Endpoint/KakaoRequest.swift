//
//  KakaoRequest.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation

enum KakaoRequest: NetworkRequest{
    case placeSearch(query: String)
    case reverseGeocoding(longitude: String, latitude: String)
    
    var baseURL: String{
        return NetworkURL.kakaoMap
    }
    
    var path: String{
        switch self{
        case .placeSearch: //키워드로 장소 검색
            return "/search/keyword"
        case .reverseGeocoding:
            return "/geo/coord2address"
        }
    }
    
    var parameters: [String : Any]{
        switch self{
        case .placeSearch(let query):
            return ["query": query]
        case .reverseGeocoding(let longitude, let latitude):
            return ["x": longitude, "y": latitude]
        }
    }
    
    var headers: [String : String]{
        return ["Authorization": APIKey.KAKAO_LOCAL_API_KEY]
    }
}

