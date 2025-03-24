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
    
    func asUrlRequest() -> URLRequest{
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)!
        
        if method == .get {
            components.queryItems = parameters.map{
                URLQueryItem(name: $0.key, value: "\($0.value)")
            }
        }
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = method.rawValue
        
        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }
        
        if method == .post{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization
                .data(withJSONObject: parameters)
        }
        
        return request
    }
}
