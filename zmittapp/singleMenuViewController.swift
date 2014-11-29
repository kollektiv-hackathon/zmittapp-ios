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
    
    var titleHeight = CGFloat(120)
    var padding = CGFloat(25.0)
    
    @IBOutlet weak var name: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup background
        self.view.backgroundColor = UIColor.clearColor()
        
        // create title area
        self.createTitle()
        
        
        var menuView = UIScrollView(frame: CGRectMake(0, titleHeight + UIApplication.sharedApplication().statusBarFrame.height, self.view.frame.width, self.view.frame.height - titleHeight - 67 - 25))
        
        var contentY = CGFloat(0);
        
        // paint menu items to screen
        for menu in restaurant.data.menu {
            
            var newMenu = self.createMenu(menu)

            newMenu.frame.origin.y = contentY
            
            contentY += newMenu.frame.height
            contentY += 10 // additional margin bottom to fully display last menu item
            
            menuView.addSubview(newMenu)
            //menuView.sizeToFit()
            
        }
        
        // no menus found
        if restaurant.data.menu.count == 0 {
            
            var label = UILabel()
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont(name: "Brandon Grotesque", size: 20)
            label.lineBreakMode =  NSLineBreakMode.ByWordWrapping // or NSLineBreakMode.ByWordWrapping
            label.numberOfLines = 0
            label.text =  "Keine Menus gefunden"
            label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            
            label.frame = CGRectMake(padding, padding, self.view.frame.width - self.padding * 2, 50)

            menuView.addSubview(label)
            
        }
        
        menuView.contentSize = CGSizeMake(self.view.frame.width, contentY)
        
        self.view.addSubview(menuView)
        
    }
    
    func createTitle() {
        

        
        var statusbarHeight = UIApplication.sharedApplication().statusBarFrame.height
        
        // create view for title area
        var titleArea = UIView(frame: CGRectMake(0, statusbarHeight, self.view.frame.width, titleHeight))
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
    
    func createMenu(menu: menuData) -> UIView {
        
        var dividerSize =  self.view.frame.width - padding * 2
        
        var menuView = UIView(frame: CGRectMake(padding, 0, self.view.frame.width - self.padding * 2, 0))
        
        var appetizer = self.getDynamicLabel(menu.appetizer, last: false)
        var main_course = self.getDynamicLabel(menu.main_course, last: false)
        main_course.frame.origin.y = appetizer.frame.height
        
        var dessert = self.getDynamicLabel(menu.desert, last: false)
        dessert.frame.origin.y = appetizer.frame.height + main_course.frame.height
        
        var number = NSString(format: "CHF %.2f", menu.price)
        
        var price = self.getDynamicLabel(number, last: true)
        price.frame.origin.y = appetizer.frame.height + main_course.frame.height + dessert.frame.height
        
        menuView.frame.size.height = appetizer.frame.height + main_course.frame.height + dessert.frame.height + price.frame.size.height
        
        menuView.addSubview(appetizer)
        menuView.addSubview(main_course)
        menuView.addSubview(dessert)
        menuView.addSubview(price)
        
        return menuView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDynamicLabel(text: String, last: Bool) -> UIView {
        
        var view = UIView()
        
        var label = UILabel()
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "Brandon Grotesque", size: 26)
        label.lineBreakMode =  NSLineBreakMode.ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.text =  text
        label.frame.size.width = self.view.frame.width - self.padding * 2
        
        label.sizeToFit()

        label.frame.size.width = self.view.frame.width - self.padding * 2
        
        label.frame.size.height += 26 // add padding

        // create divider
        
        var divider: UIImageView!
        
        if(last){
            
            divider = UIImageView(image: UIImage(named: "separatorLine"))
            
            var newSeparatorWidth = self.view.frame.width - padding * 2
            var newSeparatorHeight = divider.frame.size.height / (divider.frame.width / newSeparatorWidth)
            
            divider.frame = CGRectMake(0,
                label.frame.height,
                newSeparatorWidth, newSeparatorHeight)
            
        }else{
            
            divider = UIImageView(image: UIImage(named: "divider"))
            divider.frame = CGRectMake((self.view.frame.width  - self.padding * 2) / 2 - 3, label.frame.height , 6, 6)
            
        }

        
        view.frame.size.height += label.frame.height
        view.frame.size.height += divider.frame.height
        
        view.addSubview(divider)
        view.addSubview(label)


        return view
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}

