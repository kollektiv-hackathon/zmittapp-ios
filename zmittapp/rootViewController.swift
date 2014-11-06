//
//  SecondViewController.swift
//  zmittapp
//
//  Created by Brian Mc Alister on 03/11/14.
//  Copyright (c) 2014 Brian Mc Alister. All rights reserved.
//

import UIKit
import Alamofire

class rootViewController: UIViewController {
    
    // will be set from mainViewController
    var restaurant : Restaurant!
    
    // IBOutlets
    @IBOutlet weak var _lokalName: UILabel!
    @IBOutlet weak var _lokalEmail: UILabel!
    @IBOutlet weak var _lokalPhone: UILabel!
    @IBOutlet weak var _lokalLat: UILabel!
    @IBOutlet weak var _lokalLng: UILabel!
    
    @IBOutlet weak var _lokalMenu: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // setup background
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bg")!)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

