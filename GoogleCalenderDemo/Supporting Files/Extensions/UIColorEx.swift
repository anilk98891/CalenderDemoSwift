//
//  UIColorEx.swift
//  GoogleCalenderDemo
//
//  Created by Anil Kumar on 27/02/19.
//  Copyright © 2019 Busywizzy. All rights reserved.
//

import Foundation
import  UIKit

extension UIColor {
    func getBGEventColor()->UIColor{
        return UIColor.init(red: 108.0/255.0, green: 158.0/255.0, blue: 249.0/255.0, alpha: 1.0)
    }
    
    func getBGTaskColor()->UIColor{
        return UIColor.init(red: 253.0/255.0, green: 104.0/255.0, blue: 33.0/255.0, alpha: 1)
    }
}
