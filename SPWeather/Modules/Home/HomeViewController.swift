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

    var viewModel: HomeViewModelInterface?

    init(viewModel: HomeViewModelInterface,
         navigator: Navigator) {
        self.viewModel = viewModel
        super.init(nibName: Self.reuseID, bundle: nil)
        self.navigator = navigator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var debouncer: Debouncer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindings()
    }
    
    private func setupUI() {
        title = "Home"
        debouncer = Debouncer(delay: 0.5)
        HomeTableViewCell.registerNib(in: tableView)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
    }
    
    private func bindings() {
        viewModel?.didUpdateViewState = { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.updateView()
            }
        }
        viewModel?.initalViewState()
    }
    
    private func updateView() {
        guard let viewModel = self.viewModel else { return }
        switch viewModel.viewState {
        case .empty:
            view.bringSubviewToFront(emptyView)
        case .seaching, .history:
            view.bringSubviewToFront(tableView)
        default: break
        }
        tableView.reloadData()
    }
    
    private func pushWeatherDetail(with city: String) {
        guard let viewModel = viewModel else { return }
        navigator.show(segue: .weatherDetail(viewModel.createWeatherDetailViewModel(city: city)),
                       sender: self,
                       transition: .push)
    }
}

extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar,
                   textDidChange searchText: String) {
        debouncer.call(action: { [weak self] in
            self?.searchBar.showsCancelButton = true
            self?.viewModel?.search(query: searchText)
        })
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.text = ""
        self.searchBar.showsCancelButton = false
        self.searchBar.resignFirstResponder()
        viewModel?.resetViewState()
    }
}

extension HomeViewController: UITableViewDelegate,
                              UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HomeTableViewCell.dequeueReusableCell(in: tableView, for: indexPath)
        if let viewModelItem = viewModel?.dataForCell(at: indexPath) {
            cell.bind(viewModelItem: viewModelItem)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let viewModelItem = viewModel?.dataForCell(at: indexPath) else { return }
        switch viewModelItem {
        case .searching(let result):
            guard !result.areaName.isEmpty else { return }
            pushWeatherDetail(with: result.areaName[0].value)
        case .searchHistory(let city):
            guard let name = city.name else { return }
            pushWeatherDetail(with: name)
        default: break
        }
    }
}
