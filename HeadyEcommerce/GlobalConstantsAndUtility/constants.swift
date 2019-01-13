//
//  constants.swift
//  HeadyEcommerce
//
//  Created by Roshan Soni on 04/01/19.
//  Copyright © 2019 Personal. All rights reserved.
//

import UIKit

let SERVER_URL = "https://stark-spire-93433.herokuapp.com/json"

let APP_FONT_COLOR = UIColor.init(red: 102.0/255.0, green: 102.0/255.0, blue: 102.0/255.0, alpha: 1.0)

enum TYPES {
    case category
    case product
    case noCategory
}

enum PRODUCT_RANKING:String {
    case view_count = "viewCount"
    case order_count = "orderedCount"
    case shares = "sharedCount"
}
