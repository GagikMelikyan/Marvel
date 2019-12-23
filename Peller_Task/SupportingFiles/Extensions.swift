//
//  Extensions.swift
//  Peller_Task
//
//  Created by User on 12/19/19.
//  Copyright © 2019 GagikMelikyan. All rights reserved.
//

import Foundation
import UIKit

extension UIResponder {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableView {
    func registerCells(names: [String]) {
        for name in names {
            register(UINib(nibName: name, bundle: nil), forCellReuseIdentifier: name)
        }
    }
}
