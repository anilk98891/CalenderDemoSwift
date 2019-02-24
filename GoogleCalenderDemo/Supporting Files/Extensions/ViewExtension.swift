//
//  ViewExtension.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 18/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import  UIKit
extension UIView {
    func viewEmptyView(view : UIView)-> UIView {
        self.backgroundColor = .gray
        self.alpha = 0.5
        self.frame = CGRect.init(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        return self
    }
}
