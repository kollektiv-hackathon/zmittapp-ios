//
//  dailymenuViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 08/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class dailymenuViewController: UIPageViewController {
    
    var restaurants = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove view background
         self.view.backgroundColor = UIColor.clearColor()
        
        self.getAllRestaurants()
        
    }
    
    func getAllRestaurants() {
        
        // get all subscribed restaurants
        Alamofire.request(.GET, Router.userSubscriptions(1))
            
            .responseJSON { (_, _, JSON, _) in
                
                if let jsonResponse = JSON as? Array<[String:AnyObject]>{ // multiple restaurants as repsonse
                    
                    // loop through response
                    for restaurant in jsonResponse {
                        
                        self.addRestaurant(restaurant)
                        
                        
                    }
                    
                } else if let jsonResponse = JSON as? [String: AnyObject] { // single restaurant as response
                    
                    self.addRestaurant(jsonResponse)
                    
                }else{
                    
                    // data not correct format
                    println("requested data could not be formatted")
                    
                }
                
                // get menus for restaurants
                self.getAllMenus()
                
        };

    }
    
    func getAllMenus() {
        
        for (index, restaurant) in enumerate(self.restaurants) {
            
            // get all menus for current restaurant
            Alamofire.request(.GET, Router.menuItems(restaurant.data.id))
                .responseJSON { (_, _, JSON, _) in
                    
                    if let jsonResponse = JSON as? Array<[String:AnyObject]>{ // multiple restaurants as repsonse
                        
                        println(jsonResponse)
                        
                        // loop through response
                        for menu in jsonResponse {
                            
                            restaurant.addMenu(self.createMenu(menu))
                            
                        }
                        
                    } else if let jsonResponse = JSON as? [String: AnyObject] { // single restaurant as response
                        
                        println(JSON)
                        
                        restaurant.addMenu(self.createMenu(jsonResponse))
                        
                    }else{
                        
                        // data not correct format
                        println("requested data could not be formatted")
                        
                    }
                    
            };
            
            if(index >= self.restaurants.count ){
                // looped through all restaurants
                println(self.restaurants[0].data.menu)
            }
            
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // handle api response
    func addRestaurant(restaurant: [String:AnyObject]) {
        
        // prepare struct with supplied data
        var newData = restaurantData(
            id:     restaurant["id"] as Int,
            name:   restaurant["name"] as String,
            phone:  restaurant["phone"] as String,
            lat:    restaurant["lat"] as Double,
            lng:    restaurant["lon"] as Double,
            email:  restaurant["email"] as String,
            menu:   [menuData](),
            distance: 0.0
        )
        
        // instantiate new Restaurant with fetched data
        var newRest: Restaurant = Restaurant(data: newData)
        
        // append newly fetched restaurant to instance variable
        self.restaurants.append( newRest as Restaurant )
    }
    
    
    // create new menu struct
    func createMenu(menu: [String:AnyObject]) -> menuData {
        
        // prepare struct with supplied data
        var newData = menuData(
            id:             menu["id"] as Int,
            appetizer:      menu["appetizer"] as String,
            main_course:    menu["main_course"] as String,
            desert:         menu["desert"] as String,
            price:          menu["price"] as Double,
            date:           menu["date"] as String,
            vegetarian:     menu["vegetarian"] as Bool,
            vegan:          menu["vegan"] as Bool
        )
        
        return newData
        
    }
    
}

