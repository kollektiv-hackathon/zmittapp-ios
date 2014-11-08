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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // remove view background
        self.view.backgroundColor = UIColor.clearColor()
        
        self.getAllRestaurants()
       
    }
    
    func instantiatePageViewController(){
        self.newPageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        var firstView = self.viewControllerAtIndex(0)
        
        self.newPageViewController?.dataSource = self
        self.newPageViewController?.delegate = self
        
        self.newPageViewController?.setViewControllers([firstView!], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: {done in })
        
        //self.pageViewController?.setViewControllers([firstView], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
        
        self.addChildViewController(self.newPageViewController!)
        self.view.addSubview(self.newPageViewController!.view)
        self.newPageViewController?.didMoveToParentViewController(self)
    }
    
    func getAllRestaurants() {
        
        var id = UIDevice.currentDevice().identifierForVendor.UUIDString as String
        
        println(id)
        
        // get all subscribed restaurants
        Alamofire.request(.GET, Router.userSubscriptions(id))
            
            .responseJSON { (_, response, JSON, error) in
                
                if response?.statusCode == 404 {
                    
                    Alamofire.request(.POST, Router.createUser, parameters: ["user[uid]": id])
                        .responseJSON { (request, response, JSON, error) in
                            
                            println(request)
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
            
            if(index >= self.restaurants.count - 1 ){
                // looped through all restaurants; data is ready!
                
                self.setupData()
                self.instantiatePageViewController()
                println(self.restaurants[0].data.menu)
            }
            
            iterationcount++;
            
        }
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // handle api response
    func addRestaurant(restaurant: [String:AnyObject]) {
        
        println(restaurant)
        
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
    
    func setupData() {
        
        var test = UILabel(frame: CGRectMake(35, 35, self.view.frame.width - 70, 80))
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as singleMenuViewController).pageIndex
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index!--
        
        println("Decreasing Index: \(index)")
        
        return self.viewControllerAtIndex(index!)
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        println(viewController)
        
        
        
        var index = (viewController as singleMenuViewController).pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index!++
        
        println("Increasing Index: \(index)")
        
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
        println(self.restaurants.count)
        return self.restaurants.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}

