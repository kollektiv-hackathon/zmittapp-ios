//
//  Restaurant.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

var zmRest: zmRestaurant = zmRestaurant();

class zmRestaurant: NSObject {

    
    override init(){
        
    }
    
    // get all restaurants and save to restaurants object
    func getAll(completion: ((data: [[String:AnyObject]]) -> Void)!){
        
        var restaurants: [[String:AnyObject]]!
        
        Alamofire.request(.GET, Router.restaurants)
            .responseJSON { (_, _, JSON, _) in
                
                restaurants = self.parseRestaurantData(JSON!)
                    
                // run callback
                if((completion) != nil){
                    completion(data: restaurants)
                }
        };
        
    }
    
    // get menus of each restaurant and save to menus Array
    func getAllMenus(restaurants: [[String: AnyObject]], completion: ((data: [Int: [[String:AnyObject]]]) -> Void)!){
        
        var menuItems : [Int: [[String:AnyObject]]]!
        var count = 0
        
        for index in 0...restaurants.count - 1 {
            
            var rID : Int = restaurants[index]["id"] as Int
            
            Alamofire.request(.GET, Router.menuItems(rID))
                .responseJSON { (_, _, JSON, _) in
                    
                    // initialize menuItems if nil
                    if(menuItems == nil){
                        menuItems = [rID: self.parseMenuData(JSON!)]
                    }else{
                        menuItems[rID] = self.parseMenuData(JSON!)
                    }
                    
                    // run callback on last cycle
                    if(count == restaurants.count - 1 && (completion) != nil){
                        completion(data: menuItems)
                    }
                    
                    count++
                    
            };
            
        }
        
    }
    
    // handle request body
    func parseMenuData(JSON: AnyObject) -> [[String:AnyObject]] {
        
        if let jsonResult = JSON as? Array<[String: AnyObject]>  {
            // got array
            
            return jsonResult
            
            
        }else if let jsonResult = JSON as? [String: AnyObject]{
            // got single object
            
            return [jsonResult]
            
            
        }else{
            // handle result format errors here
            println("request result format error: ")
            println(JSON)
            
            // return empty
            return [[String:AnyObject]]()
        }
        
    }
    
    
    // handle request body
    func parseRestaurantData(JSON: AnyObject) -> [[String:AnyObject]] {
        
        if var jsonResult = JSON as? Array<[String: AnyObject]>  {
            // handle Array
            
            return jsonResult
            
            
        }else if let jsonResult = JSON as? [String: AnyObject]{
            // handle single object
            
            return [jsonResult]
            
            
        }else{
            // handle result format errors here
            println("request result format error: ")
            println(JSON)
            
            // return empty
            return [[String:AnyObject]]()
        }
        
    }

}
