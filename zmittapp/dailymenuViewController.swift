//
//  dailymenuViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 08/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class dailymenuViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var restaurants = [Restaurant]()
    var newPageViewController : UIPageViewController?
    var currentIndex: Int = 0
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onSubscriptionsChanged:", name:"SubscriptionsChanged", object: nil)
        
        // spin the fuck
        self.activityIndicator.startAnimating()
        self.activityIndicator.hidesWhenStopped = true
        
        // remove view background
        self.view.backgroundColor = UIColor.clearColor()
        
        self.getAllRestaurants()
       
    }
    
    func onSubscriptionsChanged(notification: NSNotification){
        // Observer: is executed when user changes restaurant subscription -> reload subscribed restaurants of this user.
        self.getAllRestaurants();
    }
    
    func instantiatePageViewController(){
        
        // return if pageViewController already instantiated
        if self.newPageViewController != nil {
            var firstView = self.viewControllerAtIndex(0)
            
            self.newPageViewController?.setViewControllers([firstView!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: {done in })
            
            return
        }
        
        self.newPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController

        var firstView = self.viewControllerAtIndex(0)
        
        self.newPageViewController?.dataSource = self
        self.newPageViewController?.delegate = self
        
        self.newPageViewController?.setViewControllers([firstView!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: {done in })
        
        //self.pageViewController?.setViewControllers([firstView], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        self.newPageViewController?.view.frame = CGRectMake(0, 0, self.view.frame.width, super.view.frame.height - 50)
        
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(red: 1/255*172, green: 1/255*161, blue: 1/255*141, alpha: 1)
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(red: 1/255*72, green: 1/255*67, blue: 1/255*63, alpha: 1)
        
        self.addChildViewController(self.newPageViewController!)
        self.view.addSubview(self.newPageViewController!.view)
        self.newPageViewController?.didMoveToParentViewController(self)
        
        // hide loader
        self.activityIndicator.stopAnimating()


    }
    
    func getAllRestaurants() {
        
        self.restaurants.removeAll(keepCapacity: false)
        
        var id = "11CF2061-9BC4-4D80-9C1B-A1055EF25457" //UIDevice.currentDevice().identifierForVendor.UUIDString as String
        
        // get all subscribed restaurants
        Alamofire.request(.GET, Router.userSubscriptions(id))
            
            .responseJSON { (_, response, JSON, error) in
                
                if response?.statusCode == 404 {
                    
                    Alamofire.request(.POST, Router.createUser, parameters: ["user[uid]": id])
                        .responseJSON { (request, response, JSON, error) in
                            
                            println("created new user for this device")
                            
                            // hide loader
                            self.activityIndicator.stopAnimating()
                            
                            //
                            // TODO: display info for new user here
                            //
                    };
                    
                    println("no user available")

                }else{
                    
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
                    
                    
                }
                
        };

    }
    
    func getAllMenus() {
        
        var iterationcount = 0
        
        for (index, restaurant) in enumerate(self.restaurants) {
            
            // get all menus for current restaurant
            Alamofire.request(.GET, Router.menuItems(restaurant.data.id))
                .responseJSON { (_, _, JSON, _) in
                    
                    if let jsonResponse = JSON as? Array<[String:AnyObject]>{ // multiple restaurants as repsonse
                        
                        for menu in jsonResponse {
                            var m = self.createMenu(menu)
                            var today = NSCalendar.currentCalendar().components(NSCalendarUnit.EraCalendarUnit|NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit, fromDate: NSDate() );
                            var menuDate = NSCalendar.currentCalendar().components(NSCalendarUnit.EraCalendarUnit|NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit|NSCalendarUnit.DayCalendarUnit, fromDate: m.date );
                            if(today.isEqual(menuDate)){
                                restaurant.addMenu(self.createMenu(menu))
                            }
                            
                        }
                        
                    } else if let jsonResponse = JSON as? [String: AnyObject] { // single restaurant as response
                        
                        restaurant.addMenu(self.createMenu(jsonResponse))
                        
                    }else{
                        
                        // data not correct format
                        println("requested data could not be formatted")
                        
                    }
                    
                    if(index >= self.restaurants.count - 1 ){
                        // looped through all restaurants; data is ready!
                        
                        self.instantiatePageViewController()
                    }
                    
                    iterationcount++;
                    
            };
            
            
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
        
        // append newly fetched restaurant to instance variable
        self.restaurants.append( newRest as Restaurant )
    }
    
    
    // create new menu struct
    func createMenu(menu: [String:AnyObject]) -> menuData {
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
        
        return newData
        
    }
    
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as singleMenuViewController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index!--
        
        return self.viewControllerAtIndex(index!)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        
        var index = (viewController as singleMenuViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index!++
        
        if index == self.restaurants.count {
            return nil;
        }
        return self.viewControllerAtIndex(index!)
        
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        
        if index > self.restaurants.count {
            return nil;
        }
        
        // Create a new view controller and pass suitable data.
        //let view = UIViewController(nibName: "singleMenuView", bundle: nil) as singleMenuViewController
        
        let view = self.storyboard?.instantiateViewControllerWithIdentifier("singleMenuView") as singleMenuViewController

        view.restaurant = self.restaurants[index]
        view.pageIndex = index
        
        return view
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.restaurants.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

