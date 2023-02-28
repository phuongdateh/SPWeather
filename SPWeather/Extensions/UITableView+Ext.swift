//
//  UITableView.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>(_ type: T.Type, forIndexPath indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withIdentifier: type.reuseID, for: indexPath) as? T
    }
}
