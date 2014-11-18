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
    static let baseURLString = "http://api.zmittapp.ch/"

    case restaurants
    case restaurantsAtLocation
    case restaurant(Int)
    case menuItems(Int)
    case menuItem(Int, Int)
    case userSubscriptions(String)
    case createUser
    case subscribe(Int, String)
    case unsubscribe(Int, String)
    
    var URLString: String {
        let path: String = {
            switch self {
            case .restaurants:
                return "restaurants/"
            case .restaurantsAtLocation:
                return "restaurants/location"
            case .restaurant(let id):
                return "restaurants/\(id)"
            case .menuItems(let restaurantId):
                return "restaurants/\(restaurantId)/menuitems"
            case .userSubscriptions(let userId):
                return "user/\(userId)/subscriptions"
            case .menuItem(let restaurantId, let menuId):
                return "restaurants/\(restaurantId)/menuitems/\(menuId)"
            case .createUser(let userId):
                return "user/"
            case .subscribe(let restaurantId, let userId):
                return "restaurants/\(restaurantId)/subscribe/\(userId)"
            case .unsubscribe(let restaurantId, let userId):
                return "restaurants/\(restaurantId)/unsubscribe/\(userId)"
            default:
                return ""
            }
        }()
        return Router.baseURLString + path
    }
}