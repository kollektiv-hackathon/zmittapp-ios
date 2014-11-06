//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit

class rootTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // clear background
        self.tabBar.tintColor = UIColor(red: 1/255*234, green: 1/255*231, blue: 1/255*220, alpha: 1)
        self.tabBar.barTintColor = UIColor(red: 1/255*37, green: 1/255*31, blue: 1/255*29, alpha: 1)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

