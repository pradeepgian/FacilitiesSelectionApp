//
//  Facility.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation

struct FacilityOption: Codable {
    let name: String
    let icon: String
    let id: String
}

struct Facility: Codable {
    let facilityId: String
    let name: String
    let options: [FacilityOption]
    
    private enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case name
        case options
    }
}

struct Exclusion: Codable {
    let facilityId: String
    let optionsId: String
    private enum CodingKeys: String, CodingKey {
        case facilityId = "facility_id"
        case optionsId = "options_id"
    }
}

struct FacilitiesResponse: Codable {
    let facilities: [Facility]
    let exclusions: [[Exclusion]]
}
