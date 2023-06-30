//
//  FacilitySelectionController.swift
//  FacilitiesSelectionApp
//
//  Created by Pradeep Gianchandani on 30/06/23.
//

import Foundation
import UIKit
import Combine

class FacilitySelectionController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let facilitiesViewModel: FacilityListViewModel = {
        let apiService = APIService()
        let facilityRepository = FacilitiesDataRepository(apiService: apiService)
        let viewModel = FacilityListViewModel(facilityRepository: facilityRepository)
        return viewModel
    }()
    
    
    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let facilityCellIdentifier = "FacilityCell_Identifier"
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        facilitiesViewModel.fetchFacilitiesData()
        listenToFacilityListViewModel()
    }
    
    private func listenToFacilityListViewModel() {
        facilitiesViewModel.facilities
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        facilitiesViewModel.error
            .sink { [weak self] error in
                print("error = \(error.localizedDescription)")
                self?.activityIndicator.stopAnimating()
            }
            .store(in: &cancellables)
        facilitiesViewModel.isLoading.sink { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        .store(in: &cancellables)
    }
    
    
    private func setupUI() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: facilityCellIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.fillSuperview()
        self.view.addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
        activityIndicator.startAnimating()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return facilitiesViewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facilitiesViewModel.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: facilityCellIdentifier, for: indexPath)
        let option = facilitiesViewModel.facilityOption(at: indexPath)
        cell.textLabel?.text = option.name
        cell.imageView?.image = UIImage(named: option.icon)
        cell.accessoryType = facilitiesViewModel.getAccesoryType(for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        // Check if the selected combination is excluded
        if facilitiesViewModel.isCombinationExcluded(at: indexPath) {
            let alert = UIAlertController(title: "Warning", message: "You are not allowed to select this combination.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        } else {
            facilitiesViewModel.updateSelectedOptions(at: indexPath)
            tableView.reloadData()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return facilitiesViewModel.titleForSection(section)
    }
    
}
