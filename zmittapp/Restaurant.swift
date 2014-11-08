//
//  Restaurant.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit

// define data a restaurant holds
struct restaurantData {
    var id: Int!
    var name: String!
    var phone: String!
    var lat: Double!
    var lng: Double!
    var email: String!
    var menu: [menuData]!
    var distance: Double! = 0.0
}

// define data a menu holds
struct menuData {
    var id: Int!
    var appetizer: String!
    var main_course: String!
    var desert: String!
    var price: Double!
    var date: String!
    var vegetarian: Bool!
    var vegan: Bool!
}

class Restaurant: NSObject {
    
    // restaurant data
    var data: restaurantData!
    
    // holds timestamp when Restaurant has last been updated
    var updatedAt: NSDate!
    
    init (data: restaurantData) {

        super.init()
        
        // set new data
        self.setData(data)
        
    }
    
    func setData(data: restaurantData) {
        
        // set new data
        self.data = data
        
        // update timestamp
        self.updatedAt = NSDate()
    }
    
    // add menu to Restaurant
    func addMenu(data: menuData) {
        
        // append menu to restaurant
        self.data.menu.append(data)
    }
    
    
}