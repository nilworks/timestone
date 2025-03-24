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
        case .placeSearch(let query):
            return "/search/keyword?query=\(query)"
        }
    }
    
    var parameters: [String : Any]{
        [:]
    }
    
    var headers: [String : String]{
        return ["Authorization": APIKey.KAKAO_LOCAL_API_KEY]
    }
}

