//
//  FirstViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class mainTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        
        // instanciate new Restaurant with fetched data
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
        let cell: UITableViewCell = _overviewTable.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as UITableViewCell
        
        
        var mainLabel = UILabel(frame: CGRectMake(0, 10, cell.frame.width, cell.frame.height / 2))
        cell.contentView.addSubview(mainLabel)
        mainLabel.text = self.restaurants[indexPath.row].data.name
        mainLabel.font = UIFont(name: "Brandon Grotesque", size: 33)
        mainLabel.textColor = UIColor(red: 1/255*50, green: 1/255*42, blue: 1/255*39, alpha: 1)
        
        var smallLabel = UILabel(frame: CGRectMake(0, cell.frame.height/2 - 5, cell.frame.width, cell.frame.height / 2))
        cell.contentView.addSubview(smallLabel)
        smallLabel.text = "Schiffbaustrasse 10, 8035 Zürich"//self.restaurants[indexPath.row].data.email
        smallLabel.font = UIFont(name: "BrandonGrotesque-RegularItalic", size: 17)
        smallLabel.textColor = UIColor(red: 1/255*50, green: 1/255*42, blue: 1/255*39, alpha: 1)

        
        // set cell label text
        //cell.textLabel.text = self.restaurants[indexPath.row].data.name
        //cell.detailTextLabel?.text = self.restaurants[indexPath.row].data.email
        
        // set table view cell style
        
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
    
    //
    // memory
    //
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

