//
//  ViewController.swift
//  StockEye
//
//  Created by Ankit Saxena on 07/07/21.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController {
    
    private lazy var searchController: UISearchController = {
        let sc = UISearchController(searchResultsController: nil)
        sc.searchResultsUpdater = self
        sc.delegate = self
        sc.obscuresBackgroundDuringPresentation = false
        sc.searchBar.placeholder = "Enter a company name or symbol"
        sc.searchBar.autocapitalizationType = .allCharacters
        return sc
    }()

    private let apiService = APIService()
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        observeForm()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
    }
    
    private func observeForm() {
        $searchQuery.debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink {[weak self] searchquery in
                guard let self = self else { return }
                self.apiService.fetchSymbolPublisher(keyword: searchquery).sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error is \(error.localizedDescription)")
                    }
                } receiveValue: { searchResults in
                    print("Search Results are \(searchResults)")
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let hasQuery = searchController.searchBar.text, !hasQuery.isEmpty else { return }
        searchQuery = hasQuery
    }

}

//MARK: Constants
let CELL_ID = "cellId"
