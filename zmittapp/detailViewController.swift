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
    
    
    @IBOutlet weak var subscribeSwitch: UISwitch!
    //TODO: api getter call to determine state of switch (true/false)
    @IBAction func subscribe(sender: UISwitch) {
        var userId = "11CF2061-9BC4-4D80-9C1B-A1055EF25457" //UIDevice.currentDevice().identifierForVendor.UUIDString as String
        if(subscribeSwitch.on){
            Alamofire.request(.PUT, Router.subscribe(restaurant.data.id, userId))
                .responseJSON { (request, _, JSON, _) in
                    println(request)
                    println(JSON)
                }
        } else {
            Alamofire.request(.PUT, Router.unsubscribe(restaurant.data.id, userId))
                .responseJSON { (request, _, JSON, _) in
                    println(request)
                    println(JSON)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup view before requesting menu data
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
    
    // handle api response
    func addMenu(menu: [String:AnyObject]) {
        
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

