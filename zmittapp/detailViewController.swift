//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class detailViewController: UIViewController {
    
    // will be set from mainViewController
    var restaurant : Restaurant!
    
    // IBOutlets
    @IBOutlet weak var _lokalName: UILabel!
    @IBOutlet weak var _lokalEmail: UILabel!
    @IBOutlet weak var _lokalPhone: UILabel!
    @IBOutlet weak var _lokalLat: UILabel!
    @IBOutlet weak var _lokalLng: UILabel!
    @IBOutlet weak var _lokalMenu: UILabel!
    
    var userId = "11CF2061-9BC4-4D80-9C1B-A1055EF25457" //UIDevice.currentDevice().identifierForVendor.UUIDString as String
    
    @IBOutlet weak var subscribeSwitch: UISwitch!
    
    
    @IBAction func subscribe(sender: UISwitch) {
        if(subscribeSwitch.on){
            Alamofire.request(.PUT, Router.subscribe(restaurant.data.id, self.userId))
                .responseJSON { (request, _, JSON, _) in
                    println(request)
                    self.notifyNewSubscription()
                }
        } else {
            Alamofire.request(.PUT, Router.unsubscribe(restaurant.data.id, self.userId))
                .responseJSON { (request, _, JSON, _) in
                    println(request)
                    self.notifyNewSubscription()
            }
        }
    }

    func notifyNewSubscription() {
        NSNotificationCenter.defaultCenter().postNotificationName("SubscriptionsChanged", object: nil)
    }
    
    override func viewDidLoad() {
        loadSubscribeButtonState(); //TODO: preload before user sees screen
        
        super.viewDidLoad()
        self.setupView()
        
        // get all menus for current restaurant
        Alamofire.request(.GET, Router.menuItems(self.restaurant.data.id))
            .responseJSON { (_, _, JSON, _) in
                
                if let jsonResponse = JSON as? Array<[String:AnyObject]>{ // multiple restaurants as repsonse
                    
                    // loop through response
                    for menu in jsonResponse {
                        
                        self.addMenu(menu)
                        
                        
                    }
                } else if let jsonResponse = JSON as? [String: AnyObject] { // single restaurant as response
                    
                    self.addMenu(jsonResponse)
                    
                }else{
                    
                    // data not correct format
                    println("requested data could not be formatted")
                    
                }
                
        };
        
    }
    
    private func loadSubscribeButtonState () -> Void {
        self.getSubscribedRestaurants({(subscriptions: [Restaurant]) in
            self.subscribeSwitch.on = self.determineState(subscriptions)
        })
    }
    
    private func determineState(subscriptions: [Restaurant]) -> Bool {
        let subscribed = subscriptions.filter() {$0.data.id == self.restaurant.data.id}
        return !subscribed.isEmpty
    }
    
    private func getSubscribedRestaurants(callback: ([Restaurant]) -> ()) -> Void {
        Alamofire.request(.GET, Router.userSubscriptions(self.userId))
            .responseJSON { (request, _, JSON, _) in
                var restaurants: [Restaurant] = []
                if let jsonResponse = JSON as? Array<[String:AnyObject]>{
                    for restaurant in jsonResponse {
                        var r = self.createRestaurantObject(restaurant)
                        restaurants.append(r as Restaurant)
                    }
                }
                callback(restaurants)
        }
    }
    
    private func createRestaurantObject(restaurant: [String:AnyObject]) -> Restaurant {
        // prepare struct with supplied data
        var newData = restaurantData(
            id:     restaurant["id"] as Int,
            address:restaurant["address"] as String,
            zip:    restaurant["zip"] as String,
            city:   restaurant["city"] as String,
            country:restaurant["country"] as String,
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
        
        return newRest
        
    }

    
    // handle api response
    func addMenu(menu: [String:AnyObject]) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(abbreviation: "CEST") //this doesn't take effect so far..?
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
        let date = dateFormatter.dateFromString(menu["date"] as String)
        let correctedDate = NSCalendar.currentCalendar().dateByAddingUnit( //ugly hack because abbreviation isnt working
            NSCalendarUnit.HourCalendarUnit,
            value: 1,
            toDate: date!,
            options: NSCalendarOptions(0))

        
        // prepare struct with supplied data
        var newData = menuData(
            id:             menu["id"] as Int,
            appetizer:      menu["appetizer"] as String,
            main_course:    menu["main_course"] as String,
            desert:         menu["desert"] as String,
            price:          menu["price"] as Double,
            date:           correctedDate as NSDate!,
            vegetarian:     menu["vegetarian"] as Bool,
            vegan:          menu["vegan"] as Bool
        )

        // append menu to Restaurant instance
        self.restaurant.addMenu( newData )
        
    }
    
    func setupView(){
        
        // set restaurant data
        self._lokalName.text = self.restaurant.data.name
        self._lokalEmail.text = restaurant.data.email
        self._lokalPhone.text = restaurant.data.phone
        self._lokalLat.text = String(format:"%f", restaurant.data.lat)
        self._lokalLng.text = String(format:"%f", restaurant.data.lng)
        
        self.navigationItem.title = self.restaurant.data.name
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

