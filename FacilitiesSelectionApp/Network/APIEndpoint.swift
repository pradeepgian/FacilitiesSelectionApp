//
//  APIEndpoint.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation

enum APIEndpoint {
    case fetchFacilities
}

extension APIEndpoint: EndPoint {
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    
    var host: String {
        return "my-json-server.typicode.com"
    }
    
    var path: String {
        switch self {
        case .fetchFacilities:
            return "/iranjith4/ad-assignment/db"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .fetchFacilities:
            return .get
        }
    }
}

protocol EndPoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var httpMethod: HTTPMethod { get }
}

enum HTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
}
