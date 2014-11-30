//
//  ViewController.swift
//  MTSwipeViewController
//
//  Created by Philippe Auriach on 29/11/2014.
//  Copyright (c) 2014 Philippe Auriach. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PASwipeViewControllerDataSource {
    
    var leftButtonItem:UIBarButtonItem?
    var rightButtonItem:UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.backgroundColor = getRandomColor()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func leftNavigationBarButton() -> UIBarButtonItem? {
        return leftButtonItem
    }
    
    func rightNavigationBarButton() -> UIBarButtonItem? {
        return rightButtonItem
    }
    
    func getRandomColor() -> UIColor{
        
        var randomRed:CGFloat = CGFloat(drand48())
        
        var randomGreen:CGFloat = CGFloat(drand48())
        
        var randomBlue:CGFloat = CGFloat(drand48())
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
}

