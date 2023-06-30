//
//  APIService.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation
import Combine

protocol APIServiceProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, Error>
}

class APIService: APIServiceProtocol {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request<T: Decodable>(endpoint: APIEndpoint) -> AnyPublisher<T, Error> {
        var components = URLComponents()
        components.scheme = endpoint.scheme
        components.host = endpoint.host
        components.path = endpoint.path
        guard let url = components.url else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError.invalidResponse
                }
                
                guard 200..<300 ~= httpResponse.statusCode else {
                    throw APIError.statusCode(httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

