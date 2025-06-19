//
//  NetworkManager.swift
//  timestone
//
//  Created by 이상민 on 3/23/25.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init(){}
    
    func CallbackRequest<T: Decodable>(request: NetworkRequest) async throws -> T{
        
        let urlRequest = request.asUrlRequest()
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else{
            throw NetworkError.invalidResponseType
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else{
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode)
        }
        
        do{
            return try JSONDecoder().decode(T.self, from: data)
        }catch{
            throw NetworkError.decondingFailed
        }
    }
}
