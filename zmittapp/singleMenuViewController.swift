//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class singleMenuViewController: UIViewController {
    
    // will be set from dailymenuViewController
    var restaurant : Restaurant!
    var pageIndex: Int!
    
    // display
    var restaurantTitle = UILabel()
    var borderLine = UIImage()
    
    
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup background
        self.view.backgroundColor = UIColor.clearColor()
        
        // create title area
        self.createTitle()
        
        // paint menu items to screen
        for menu in restaurant.data.menu {
            self.createMenu(menu)
        }
        
    }
    
    func createTitle() {
        
        var padding = CGFloat(25.0)
        
        var statusbarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        // create view for title area
        var titleArea = UIView(frame: CGRectMake(0, statusbarHeight, self.view.frame.width, 120))
        titleArea.backgroundColor = UIColor.clearColor()
        
        // create title label
        var titleLabel = UILabel(frame: CGRectMake(padding, 0, self.view.frame.width - padding * 2, titleArea.frame.height))
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Tangerine", size: 50)
        titleLabel.text =  self.restaurant.data.name
        
        // create UIImageView for left
        var curlyLeft = UIImageView(image: UIImage(named: "curly"))
        curlyLeft.frame = CGRectMake(padding, titleArea.frame.size.height / 2 - curlyLeft.frame.size.height / 2, curlyLeft.frame.size.width, curlyLeft.frame.size.height)
        curlyLeft.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
        
        var curlyRight = UIImageView(image: UIImage(named: "curly"))
        curlyRight.frame = CGRectMake(titleArea.frame.size.width - padding - curlyRight.frame.size.width, titleArea.frame.size.height / 2 - curlyRight.frame.size.height / 2, curlyRight.frame.size.width, curlyRight.frame.size.height)
        
        var separatorLine = UIImageView(image: UIImage(named: "separatorLine"))
        
        var newSeparatorWidth = titleArea.frame.size.width - padding * 2
        var newSeparatorHeight = separatorLine.frame.size.height / (separatorLine.frame.width / newSeparatorWidth)
        
        separatorLine.frame = CGRectMake(padding,
                                         titleArea.frame.size.height - separatorLine.frame.size.height / 2,
                                         newSeparatorWidth, newSeparatorHeight)
        
        // add elements to title area
        titleArea.addSubview(titleLabel)
        titleArea.addSubview(curlyLeft)
        titleArea.addSubview(curlyRight)
        titleArea.addSubview(separatorLine)
        
        // add title area to view
        self.view.addSubview(titleArea)

    }
    
    func createMenu(menu: menuData) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

