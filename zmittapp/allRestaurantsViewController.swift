//
//  FirstViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class allRestaurantsViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
    // will contain all restaurants for this view
    var restaurants = [Restaurant]()

    @IBOutlet var _overviewTable: UITableView!
    
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        // clear background color
        self.view.backgroundColor = UIColor.clearColor()
        self._overviewTable.separatorColor = UIColor.clearColor()
        
        self._overviewTable.separatorInset = UIEdgeInsetsZero
        
        /*CGRect tableRect = self.view.frame;
        tableRect.origin.x += tableBorderLeft; // make the table begin a few pixels right from its origin
        tableRect.size.width -= tableBorderLeft + tableBorderRight; // reduce the width of the table
        tableView.frame = tableRect;*/
        
        // get all restaurants
        Alamofire.request(.GET, Router.restaurants)
/*            .responseJSON{(request, response, data, error) in
                println(data)
        };*/
            
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
                
                // update table
                self._overviewTable.reloadData()
                
            };
        
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
            menu:   [menuData]()
        )
        
        // instantiate new Restaurant with fetched data
        var newRest: Restaurant = Restaurant(data: newData)
        
        // append newly fetched restaurant to instance variable
        self.restaurants.append( newRest as Restaurant )
    }
    
    
    //
    // tableView operations
    //
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check if array available (request sent)
        return self.restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // create cell
        var cell: customTableViewCell = _overviewTable.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as customTableViewCell
        //cell.registerSubviewContent()
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // set new controller for detail view
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as detailViewController
        
        // add data to new controller
        controller.restaurant = self.restaurants[indexPath.row]
        
        // navigate to new controller
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        var customCell = cell as customTableViewCell
        
        if(!customCell.subViewRegistered){
            customCell.registerSubviewContent()
        }
        
        customCell.setContent(self.restaurants[indexPath.row].data.name, smallLabelText: "Schiffbaustrasse 10, 8035 Zürich")
        
    }
    
    
    //
    // memory
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

