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
        self.tabBar.barTintColor = UIColor(red: 1/255*72, green: 1/255*67, blue: 1/255*63, alpha: 1)
        


        

    }
    
    override func viewWillLayoutSubviews() {
        var tabFrame = self.tabBar.frame //self.TabBar is IBOutlet of your TabBar
        tabFrame.size.height = 54;
        tabFrame.origin.y = self.view.frame.size.height - 54;
        self.tabBar.frame = tabFrame;


    }

    
    override func tabBar(tabBar: UITabBar, didBeginCustomizingItems items: [AnyObject]) {
        
        
       // self.tabBarItem.setTitlePositionAdjustment(UIOffset( horizontal: 50, vertical: -60))
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

