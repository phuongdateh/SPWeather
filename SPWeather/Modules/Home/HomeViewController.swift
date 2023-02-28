//
//  HomeViewController.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import UIKit

class HomeViewController: ViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    private var debouncer: Debouncer!
    var viewModelItems: [HomeViewModelItem]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.bindings()
    }
    
    private func setupUI() {
        title = "Home"
        self.debouncer = Debouncer(delay: 0.5)
        tableView.register(UINib(nibName: HomeTableViewCell.reuseID, bundle: nil), forCellReuseIdentifier: HomeTableViewCell.reuseID)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func bindings() {
        if let viewModel = viewModel as? HomeViewModel {
            viewModel.didChangeData = {[weak self] items in
                if let self = self {
                    self.viewModelItems = items
                    self.updateView()
                }
            }
            viewModel.initalViewState()
        }
    }
    
    private func updateView() {
        DispatchQueue.main.async {[weak self] in
            guard let self = self,
                  let viewModel = self.viewModel as? HomeViewModel else { return }
            switch viewModel.viewState {
            case .empty:
                self.view.bringSubviewToFront(self.emptyView)
            case .seaching, .history:
                self.view.bringSubviewToFront(self.tableView)
            default: break
            }
            self.tableView.reloadData()
        }
    }
    
    private func pushWeatherDetail(with city: String) {
        if let viewModel = viewModel as? HomeViewModel {
            self.navigator.show(segue: .weatherDetail(viewModel.createWeatherDetailViewModel(city: city)), sender: self, transition: .push)
        }
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.debouncer.call(action: { [weak self] in
            if let self = self, let viewModel = self.viewModel as? HomeViewModel {
                self.searchBar.showsCancelButton = true
                viewModel.search(query: searchText)
            }
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let viewModel = viewModel as? HomeViewModel {
            self.searchBar.text = ""
            self.searchBar.showsCancelButton = false
            self.searchBar.resignFirstResponder()
            viewModel.resetViewState()
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let items = self.viewModelItems {
            return items.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueCell(HomeTableViewCell.self, forIndexPath: indexPath),
           let viewModelItems = self.viewModelItems,
           viewModelItems.count > indexPath.row {
            cell.bind(viewModelItem: viewModelItems[indexPath.row])
            return cell
        }
        return .init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let viewModelItems = self.viewModelItems,
           viewModelItems.count > indexPath.row {
            let item = viewModelItems[indexPath.row]
            switch item {
            case .searching(let result):
                if result.areaName.isEmpty == false {
                    self.pushWeatherDetail(with: result.areaName[0].value)
                }
            case .searchHistory(let city):
                if let name = city.name {
                    self.pushWeatherDetail(with: name)
                }
            default:
                break
            }
        }
    }
}
