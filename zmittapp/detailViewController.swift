//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit

class detailViewController: UIViewController {
    
    var restaurant : [String:AnyObject]!
    
    @IBOutlet weak var _lokalName: UILabel!
    @IBOutlet weak var _lokalEmail: UILabel!
    @IBOutlet weak var _lokalPhone: UILabel!
    @IBOutlet weak var _lokalLat: UILabel!
    @IBOutlet weak var _lokalLng: UILabel!
    
    @IBOutlet weak var _lokalMenu: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self._lokalName.text = restaurant["name"] as? String
        self._lokalEmail.text = restaurant["email"] as? String
        self._lokalPhone.text = restaurant["phone"] as? String
        self._lokalLat.text = restaurant["lat"] as? String
        self._lokalLng.text = restaurant["lon"] as? String
        
        println(restaurant["lon"])
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

