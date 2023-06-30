//
//  APIError.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation

enum APIError: Error, Identifiable {
    case invalidURL
    case invalidResponse
    case statusCode(Int)
    case decodingFailed
    var id: String {
        switch self {
        case .invalidURL:
            return "InvalidURL"
        case .invalidResponse:
            return "InvalidResponse"
        case .statusCode(let statusCode):
            return "StatusCode\(statusCode)"
        case .decodingFailed:
            return "Decoding failed"
        }
    }
}
