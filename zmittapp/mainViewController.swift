//
//  FirstViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class mainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var data: AnyObject!
    
    @IBOutlet var overviewTable: UITableView!

    override func viewDidLoad() {
        
        // Do any additional setup after loading the view, typically from a nib.
        super.viewDidLoad()
        
        Alamofire.request(.GET, Router.restaurant(2))
            .responseJSON { (_, _, JSON, _) in
                self.data = JSON;
                self.updateView();
            };
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateView(){
        
        if let jsonResult = self.data as? Array<[String: AnyObject]>  {
            // handle Array
            
            // set restaurant source
            zmRest.restaurants = jsonResult
            
            // reload table
            overviewTable.reloadData()
        
        }else if let jsonResult = self.data as? [String: AnyObject]{
            // handle single result
            zmRest.restaurants = [jsonResult]

            // reload table
            overviewTable.reloadData()

        }else{
            // handle result format errors here
            println("request result format error: ")
            println(self.data)
        }
        
    }
    
    // TableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // check if array available (request sent)
        if(zmRest.restaurants == nil){
            return 0
        }
        return zmRest.restaurants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Error")
        
        cell.textLabel.text = zmRest.restaurants[indexPath.row]["name"] as? String

        cell.detailTextLabel?.text = zmRest.restaurants[indexPath.row]["email"] as? String
        
        return cell
    }
    
    


}

