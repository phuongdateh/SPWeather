//
//  WeatherDetailViewController.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import UIKit

class WeatherDetailViewController: ViewController {
    @IBOutlet weak var contentView: UIStackView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var contentLbl: UILabel!
    @IBOutlet weak var loadingView: UIView!

    var viewModel: WeatherDetailViewModelInterface?

    init(viewModel: WeatherDetailViewModelInterface,
         navigator: Navigator) {
        self.viewModel = viewModel
        super.init(nibName: Self.reuseID, bundle: nil)
        self.navigator = navigator
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindings()
    }
    
    private func setupUI() {
        title = "Weather Detail"
        contentLbl.numberOfLines = 0

        contentView.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        contentView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func bindings() {
        viewModel?.didUpdateViewState = { [weak self] viewState in
            DispatchQueue.main.async { [weak self] in
                self?.updateView(viewState)
            }
        }
        viewModel?.fetchWeather()
    }

    private func updateView(_ state: WeatherDetailViewModel.ViewState) {
        contentView.isHidden = state == .loading
        switch state {
        case .loading:
            showLoading()
        case .loaded:
            hideLoading()
            contentLbl.attributedText = viewModel?.contentAttributedText()
            viewModel?.downloadIcon(completion: { [weak self] data in
                DispatchQueue.main.async { [weak self] in
                    guard let data = data else { return }
                    self?.iconImageView.image = UIImage(data: data)
                }
            })
        }
    }

    private func showLoading() {
        loadingView.isHidden = false
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
    }
}
