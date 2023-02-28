//
//  HomeTableViewCell.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contentLbl: UILabel!
    
    var viewModelItem: HomeViewModelItem!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentLbl.numberOfLines = 0
    }
    
    func bind(viewModelItem: HomeViewModelItem) {
            self.viewModelItem = viewModelItem
            switch self.viewModelItem {
            case .searchFail(let message):
                contentLbl.text = message
            case .searching(let result):
                var contentStr: String = ""
                if result.areaName.isEmpty == false {
                    contentStr = result.areaName[0].value
                }
                if result.country.isEmpty == false {
                    contentStr += ", " + result.country[0].value
                }
                contentLbl.text = contentStr
            case .searchHistory(let city):
                contentLbl.text = city.name
            case .none:
                contentLbl.text = ""
            }
        }
    
}
