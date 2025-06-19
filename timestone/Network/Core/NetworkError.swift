//
//  NetworkError.swift
//  timestone
//
//  Created by 이상민 on 3/23/25.
//

import Foundation

enum NetworkErrorType: LocalizedError{
    case location
    case search
    
    var errorDescription: String?{
        switch self{
        case .location:
            return "현재 위치 정보 가져오기 실패"
        case .search:
            return "검색 결과 가져오기 실패"
        }
    }
}

enum NetworkError: Error, LocalizedError{
    case invalidURL
    case invalidResponseType
    case requestFailed(statusCode: Int)
    case decondingFailed
    case unknownResponse
    
    var errorDescription: String?{
        switch self{
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidResponseType:
            return "서버로부터 받은 응답 형식이 올바르지 않습니다."
        case .requestFailed(let statusCode):
            return "요청이 실패했습니다. (상태코드: \(statusCode))"
        case .decondingFailed:
            return "응답 데이터를 파싱하는 데 실패했습니다."
        case .unknownResponse:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
