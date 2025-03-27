//
//  KakaoRequest.swift
//  timestone
//
//  Created by 이상민 on 3/24/25.
//

import Foundation

enum KakaoRequest: NetworkRequest{
    case placeSearch(query: String)
    
    var baseURL: String{
        return NetworkURL.kakaoMap
    }
    
    var path: String{
        switch self{
        case .placeSearch:
            return "/search/keyword"
        }
    }
    
    var parameters: [String : Any]{
        switch self{
        case .placeSearch(let query):
            return ["query": query]
        }
    }
    
    var headers: [String : String]{
        return ["Authorization": APIKey.KAKAO_LOCAL_API_KEY]
    }
}

