//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit

class customTableViewCell: UITableViewCell{
    
    // cell bg images
    let cellBg = UIImageView(image: UIImage(named: "cell"))
    let cellBgActive = UIImageView(image: UIImage(named: "cellActive"))
    
    // font colour
    let fontColour = UIColor(red: 1/255*50, green: 1/255*42, blue: 1/255*39, alpha: 1)
    
    // subview content
    var mainLabel: UILabel!
    var smallLabel: UILabel!
    
    // cell size and position
    var newBounds: CGRect!
    
    // holds bool => true if subview content was already registered
    var subViewRegistered = false

    
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
    
    // sets the background image of the cell depending on it's state
    func setBg(highlight: Bool) {
        if(highlight){
            self.backgroundColor = UIColor.clearColor()
            self.backgroundView = self.cellBgActive
        }else{
            self.backgroundColor = UIColor.clearColor()
            self.backgroundView = cellBg
        }
    }
    
    // register the the subviews for this cell
    func registerSubviewContent() {
        
        // determine positions
        self.mainLabel = UILabel(frame: CGRectMake(0, 10, self.frame.width, self.frame.height / 2))
        self.smallLabel = UILabel(frame: CGRectMake(0, self.frame.height/2 - 5, self.frame.width, self.frame.height / 2))
        
        // set font and colour
        self.mainLabel.font = UIFont(name: "Brandon Grotesque", size: 26)
        self.smallLabel.font = UIFont(name: "BrandonGrotesque-RegularItalic", size: 17)
        self.mainLabel.textColor = self.fontColour
        self.smallLabel.textColor = self.fontColour
        
        // add labels to contentView
        self.contentView.addSubview(self.mainLabel)
        self.contentView.addSubview(self.smallLabel)
        
        self.subViewRegistered = true
    }
    
    // set the label text and add label to subview
    func setContent(mainLabelText: String, smallLabelText: String) {
        self.mainLabel.text = mainLabelText
        self.smallLabel.text = smallLabelText
    }
}

