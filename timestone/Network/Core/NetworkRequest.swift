//
//  NetworkRequest.swift
//  timestone
//
//  Created by 이상민 on 3/23/25.
//

import Foundation

//MARK: - Method
enum HTTPMethod: String{
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequest{
    var baseURL: String { get }
    var path: String { get }
    var parameters: [String: Any] { get }
    var headers: [String: String] { get }
    var method: HTTPMethod { get }
}

extension NetworkRequest{
    var method: HTTPMethod { .get }
    
    var url: URL{
        guard let url = URL(string: baseURL + path) else{
            fatalError("잘못된 URL: \(baseURL + path)입니다.")
        }
        return url
    }
}
