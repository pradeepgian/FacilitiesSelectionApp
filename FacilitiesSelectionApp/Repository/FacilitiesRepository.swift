//
//  FacilitiesRepository.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation
import Combine

protocol FacilityRepository {
    func fetchFacilities() -> AnyPublisher<FacilitiesResponse, Error>
}

class FacilitiesDataRepository: FacilityRepository {
    private let apiService: APIServiceProtocol
    
    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }
    
    func fetchFacilities() -> AnyPublisher<FacilitiesResponse, Error> {
        let endpoint = APIEndpoint.fetchFacilities
        return apiService.request(endpoint: endpoint)
            .mapError{ _ in
                APIError.decodingFailed
            }
            .eraseToAnyPublisher()
    }
}
