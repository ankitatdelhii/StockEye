//
//  ViewController.swift
//  StockEye
//
//  Created by Ankit Saxena on 07/07/21.
//

import UIKit
import Combine

class SearchTableViewController: UITableViewController {
    
    private enum Mode {
        case onboarding
        case search
    }
    
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
    private var searchResults: SearchResults?
    private var subscribers = Set<AnyCancellable>()
    @Published private var searchQuery = String()
    @Published private var mode: Mode = .onboarding
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupNavigationBar()
        observeForm()
        setupTableView()
    }

    private func setupNavigationBar() {
        navigationItem.searchController = searchController
        navigationItem.title = "Search"
    }
    
    private func setupTableView() {
        tableView.tableFooterView = UIView()
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
                    self.searchResults = searchResults
                    self.tableView.reloadData()
                }.store(in: &self.subscribers)
            }.store(in: &subscribers)
        
        $mode.sink {[weak self] currentMode in
            guard let self = self else { return }
            switch currentMode {
            case .onboarding:
                self.tableView.backgroundView = SearchPlaceholderView()
            case .search:
                self.tableView.backgroundView = nil
            }
        }.store(in: &subscribers)
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! SearchTableViewCell
        if let hasModel = searchResults?.items[indexPath.row] {
            cell.confureCell(with: hasModel)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults?.items.count ?? 0
    }

}

extension SearchTableViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let hasQuery = searchController.searchBar.text, !hasQuery.isEmpty else { return }
        searchQuery = hasQuery
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        mode = .search
    }

}

//MARK: Constants
let CELL_ID = "cellId"
