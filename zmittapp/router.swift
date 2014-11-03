//
//  router.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import Foundation
import Alamofire

enum Router: URLStringConvertible {
    static let baseURLString = "http://api.zmittapp.ch/app_dev.php/"

    case restaurants
    case restaurant(Int)
    case menuItems(Int)
    case menuItem(Int, Int)
    
    var URLString: String {
        let path: String = {
            switch self {
            case .restaurants:
                return "restaurants/"
            case .restaurant(let id):
                return "restaurants/\(id)"
            case .menuItems(let restaurantId):
                return "restaurants/\(restaurantId)/menuitems/"
            case .menuItem(let restaurantId, let menuId):
                return "restaurants/\(restaurantId)/menuitems/\(menuId)"
            default:
                return ""
            }
            }()
        
        return Router.baseURLString + path
    }
}