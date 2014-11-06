//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell{
    
    let cellBg = UIImageView(image: UIImage(named: "cell"))
    let cellBgActive = UIImageView(image: UIImage(named: "cellActive"))
    
    var newBounds: CGRect!

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // initially set bg
        self.setBg(false)
        
        // set custom accessoryView
        var curlyBraces = UIImageView(image: UIImage(named: "curly"))
        self.accessoryView = curlyBraces

    }
    
    override func layoutSubviews() {
        
        var inset = CGFloat(35)
        
        // only set newBounds if not already set before
        if(self.newBounds == nil){
            
            self.newBounds = CGRectMake(self.bounds.origin.x,
                                        self.bounds.origin.y,
                                        self.bounds.size.width - inset * 2,
                                        self.bounds.size.height)
  
        }
        

        
        self.bounds = self.newBounds
        

        super.layoutSubviews()
 
    }

    override func setSelected(selected: Bool, animated: Bool) {
        self.setBg(selected)
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {
        self.setBg(highlighted)

    }
    
    func setBg(highlight: Bool){
        if(highlight){
            self.backgroundColor = UIColor.clearColor()
            self.backgroundView = self.cellBgActive
        }else{
            self.backgroundColor = UIColor.clearColor()
            self.backgroundView = cellBg
        }
    }
}

