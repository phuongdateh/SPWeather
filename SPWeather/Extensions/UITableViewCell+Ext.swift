//
//  UITableView.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import UIKit

extension UITableViewCell {
    class func registerNib(in tableView: UITableView?) {
        tableView?.register(UINib(nibName: className, bundle: nil), forCellReuseIdentifier: className)
    }

    class func dequeueReusableCell(in tableView: UITableView, for indexPath: IndexPath) -> Self {
        let cell = tableView.dequeueReusableCell(withIdentifier: className, for: indexPath)
        return cell as? Self ?? self.init()
    }

    private static var className: String {
        String(describing: self)
    }
}
