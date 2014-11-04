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
    
    var restaurants : [[String:AnyObject]]!

    @IBOutlet var _overviewTable: UITableView!
    
    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        zmRest.getAll { (data) -> Void in
            
            // set restaurants
            self.restaurants = data as [[String:AnyObject]]
            
            // get all menus for fetched restaurants
            zmRest.getAllMenus(data, completion: { (data) -> Void in
                
                println(data)
                
            })
            
            // update our table view
            self._overviewTable.reloadData()
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // TableView
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check if array available (request sent)
        if(self.restaurants == nil){
            return 0
        }
        return self.restaurants.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Error")
        
        let cell: UITableViewCell = _overviewTable.dequeueReusableCellWithIdentifier("restaurantCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel.text = self.restaurants[indexPath.row]["name"] as? String

        cell.detailTextLabel?.text = self.restaurants[indexPath.row]["email"] as? String
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("detailViewController") as detailViewController
        
        controller.restaurant = self.restaurants[indexPath.row]
        
        self.navigationController?.pushViewController(controller, animated: true)
        
    }


}

