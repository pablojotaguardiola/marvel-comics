//
//  UICollectionReusableView+identifier.swift
//  marvel-comics
//
//  Created by Pablo Guardiola on 08/02/2019.
//  Copyright © 2019 Pablo Guardiola. All rights reserved.
//

import UIKit

extension UICollectionReusableView {
    static var identifier: String {
        get {
            return String(describing: self)
        }
    }
}
