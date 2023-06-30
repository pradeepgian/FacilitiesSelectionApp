//
//  FacilityListViewModel.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation
import UIKit
import Combine

class FacilityListViewModel {
    
    private let facilityRepository: FacilityRepository
    
    private var facilitiesSubject = PassthroughSubject<[Facility], Never>()
    var facilities: AnyPublisher<[Facility], Never> {
        return facilitiesSubject.eraseToAnyPublisher()
    }
    
    private var exclusionsSubject = PassthroughSubject<[[Exclusion]], Never>()
    var exclusions: AnyPublisher<[[Exclusion]], Never> {
        return exclusionsSubject.eraseToAnyPublisher()
    }
    
    private var errorSubject = PassthroughSubject<Error, Never>()
    var error: AnyPublisher<Error, Never> {
        return errorSubject.eraseToAnyPublisher()
    }
    
    private var isLoadingSubject = CurrentValueSubject<Bool, Never>(false)
    var isLoading: AnyPublisher<Bool, Never> {
        return isLoadingSubject.eraseToAnyPublisher()
    }
    
    private var cancellables: Set<AnyCancellable> = []
    private var facilitiesData = [Facility]()
    private var exclusionsData = [[Exclusion]]()
    private var optionsSelected: [String: String] = [:]
    
    init(facilityRepository: FacilityRepository) {
        self.facilityRepository = facilityRepository
    }
    
    func fetchFacilitiesData() {
        isLoadingSubject.send(true)
        facilityRepository.fetchFacilities()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSubject.send(false)
                switch completion {
                case .failure(let error):
                    self?.errorSubject.send(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                self?.facilitiesData = response.facilities
                self?.exclusionsData = response.exclusions
                self?.facilitiesSubject.send(response.facilities)
                self?.exclusionsSubject.send(response.exclusions)
            }
            .store(in: &cancellables)

    }
    
    func isCombinationExcluded(at indexPath: IndexPath) -> Bool {
        let selectFacility = facilitiesData[indexPath.section]
        let selectOption = selectFacility.options[indexPath.row]
        for exclusionGroup in exclusionsData {
            for (index, exclusion) in exclusionGroup.enumerated() {
                let isLastElement = (index == exclusionGroup.count - 1)
                if exclusion.facilityId == selectFacility.facilityId && exclusion.optionsId == selectOption.id {
                    if isLastElement {
                        return true
                    }
                } else if let optionSelected = optionsSelected[exclusion.facilityId],
                          optionSelected == exclusion.optionsId {
                    if isLastElement {
                        return true
                    }
                } else {
                    break
                }
            }
        }
        return false
    }
    
    func updateSelectedOptions(at indexPath: IndexPath) {
        let selectFacility = facilitiesData[indexPath.section]
        let selectOption = selectFacility.options[indexPath.row]
        optionsSelected[selectFacility.facilityId] = selectOption.id
    }
    
    func numberOfSections() -> Int {
        return facilitiesData.count
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return facilitiesData[section].options.count
    }
    
    func facility(at indexPath: IndexPath) -> Facility {
        return facilitiesData[indexPath.section]
    }
    
    func facilityOption(at indexPath: IndexPath) -> FacilityOption {
        let facility = facilitiesData[indexPath.section]
        return facility.options[indexPath.row]
    }
    
    func titleForSection(_ section: Int) -> String {
        let facility = facilitiesData[section]
        return facility.name
    }
    
    func selectedOption(for facility: Facility) -> String? {
        return optionsSelected[facility.facilityId]
    }
    
    func getAccesoryType(for indexPath: IndexPath) -> UITableViewCell.AccessoryType {
        let facility = facility(at: indexPath)
        let option = facilityOption(at: indexPath)
        if let selectedOption = selectedOption(for: facility), selectedOption == option.id {
            return .checkmark
        }
        return .none
    }
}

