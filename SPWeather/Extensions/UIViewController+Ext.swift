//
//  UIViewController+Ext.swift
//  SPWeather
//
//  Created by James on 28/02/2023.
//

import Foundation
import UIKit

protocol Reusable {
    static var reuseID: String {get}
}

extension Reusable {
    static var reuseID: String {
        return String(describing: self)
    }
}

extension UITableViewCell: Reusable {}
extension UIViewController: Reusable {}
