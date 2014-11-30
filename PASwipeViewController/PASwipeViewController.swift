//
//  SwipeViewController.swift
//  MTSwipeViewController
//
//  Created by Philippe Auriach on 29/11/2014.
//  Copyright (c) 2014 Philippe Auriach. All rights reserved.
//

import UIKit

protocol PASwipeViewControllerDelegate {
    func swipeViewDidSwipe(selectedIndex:Int, selectedViewController:UIViewController)
}

@objc protocol PASwipeViewControllerDataSource: NSObjectProtocol {
    func leftNavigationBarButton() -> UIBarButtonItem?
    func rightNavigationBarButton() -> UIBarButtonItem?
}

class PASwipeViewController: UIViewController, UIScrollViewDelegate {
    
    var elementsColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
    
    var delegate:PASwipeViewControllerDelegate?
    var onSwipeViewDidSwipe:((selectedIndex:Int, selectedViewController:UIViewController) -> Void)?
    
    private let navbarTitleView = UIView()
    private let navbarScrollView = UIScrollView()
    let navbarPageControl = UIPageControl()
    private var selected = -1
    
    private let scrollView = UIScrollView()
    private var viewControllers = Array<UIViewController>()
    
    init(viewControllers: Array<UIViewController>) {
        super.init()
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        scrollView.scrollEnabled = true
        scrollView.pagingEnabled = true
        scrollView.bounces = true
        scrollView.alwaysBounceHorizontal = true
        scrollView.alwaysBounceVertical = false
        scrollView.directionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        
        navbarScrollView.scrollEnabled = false
        navbarScrollView.pagingEnabled = false
        navbarScrollView.showsHorizontalScrollIndicator = false
        navbarScrollView.showsVerticalScrollIndicator = false
        
        navbarPageControl.pageIndicatorTintColor = elementsColor.colorWithAlphaComponent(0.4)
        navbarPageControl.currentPageIndicatorTintColor = elementsColor
        
        self.viewControllers = viewControllers
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        navbarTitleView.frame = self.view.bounds
        scrollView.frame = self.view.bounds
        scrollView.contentSize = CGSizeMake(self.view.bounds.width * CGFloat(viewControllers.count), self.view.frame.height)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if let frame = self.navigationController?.navigationBar.frame {
            navbarTitleView.frame = CGRectMake(frame.width/4, 0, frame.width/2, frame.height)
            
            navbarScrollView.frame = CGRectMake(0, 0, navbarTitleView.frame.width, navbarTitleView.frame.height)
            navbarScrollView.contentSize = CGSizeMake((navbarScrollView.frame.width/2) * CGFloat(viewControllers.count), navbarScrollView.frame.height)
            
            navbarTitleView.addSubview(navbarScrollView)
        }
        
        self.navigationItem.titleView = navbarTitleView
        
        var idx = 0
        for viewController in viewControllers {
            
            self.addChildViewController(viewController)
            
            var contentViewFrame = CGRectMake(0, 0, self.view.bounds.width, self.view.bounds.height - scrollView.contentInset.top)
            contentViewFrame.origin.x = CGFloat(idx) * self.view.frame.width
            viewController.view.frame = contentViewFrame
            scrollView.addSubview(viewController.view)
            
            var label = UILabel(frame: CGRectMake((navbarScrollView.frame.width/2)*CGFloat(idx), 0, navbarScrollView.frame.width/2, navbarScrollView.frame.height-13))
            label.text = viewController.title
            label.textColor = elementsColor
            label.textAlignment = NSTextAlignment.Center
            navbarScrollView.addSubview(label)
            
            idx++
        }
        
        navbarPageControl.frame = CGRectMake(0, navbarScrollView.frame.height-13, navbarScrollView.frame.width, 10)
        navbarPageControl.numberOfPages = viewControllers.count
        navbarTitleView.addSubview(navbarPageControl)
        
        //gradients
        var gradient = CAGradientLayer()
        gradient.anchorPoint = CGPointZero
        gradient.startPoint = CGPointMake(0, 0.5)
        gradient.endPoint = CGPointMake(1, 0.5)
        gradient.bounds = CGRectMake(0, 0, CGRectGetWidth(navbarTitleView.bounds), CGRectGetHeight(navbarTitleView.bounds))
        
        let outerColor = UIColor(white: 1, alpha: 0)
        let innerColor =  UIColor(white: 1, alpha: 1)
        gradient.colors = [outerColor.CGColor, innerColor.CGColor, innerColor.CGColor, outerColor.CGColor]
        gradient.locations = [0, 0.2, 0.8, 1]
        
        navbarTitleView.layer.mask = gradient
        
        self.scrollViewDidScroll(scrollView)
    }
    
    func scrollToViewController(index: Int, animated:Bool) {
        if (index != selected) {
            let duration:NSTimeInterval = animated ? 0.5 : 0
            UIView.animateWithDuration(duration, animations: { () -> Void in
                self.scrollView.contentOffset.x = CGFloat(index) * self.scrollView.frame.width
            })
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let page = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        
        let scrollPercent = scrollView.contentOffset.x / scrollView.contentSize.width
        navbarScrollView.contentOffset.x = -(navbarScrollView.frame.width/4) + scrollPercent * navbarScrollView.contentSize.width
        
        if selected != Int(page) {
            selected = Int(page)
            navbarPageControl.currentPage = selected
            delegate?.swipeViewDidSwipe(selected, selectedViewController: viewControllers[selected])
            if let onSwipeViewDidSwipe = onSwipeViewDidSwipe {
                onSwipeViewDidSwipe(selectedIndex: selected, selectedViewController: viewControllers[selected])
            }
            self.navigationItem.leftBarButtonItem = nil;
            if let leftButton = leftBarButtonItem(viewControllers[Int(page)]) {
                leftButton.tintColor = elementsColor.colorWithAlphaComponent(0.0)
                self.navigationItem.leftBarButtonItem = leftButton
            }
            self.navigationItem.rightBarButtonItem = nil;
            if let rightButton = rightBarButtonItem(viewControllers[Int(page)]) {
                rightButton.tintColor = elementsColor.colorWithAlphaComponent(0.0)
                self.navigationItem.rightBarButtonItem = rightButton
            }
        }
        
        var visibleWidth = 0 as CGFloat
        if (CGFloat(selected) * scrollView.frame.size.width) < scrollView.contentOffset.x
        {
            //main view is on the left
            visibleWidth = (CGFloat(selected+1) * scrollView.frame.size.width) - scrollView.contentOffset.x
        }
        else if (CGFloat(selected) * scrollView.frame.size.width) > scrollView.contentOffset.x {
            //main view is on the right
            visibleWidth = scrollView.frame.size.width - ((CGFloat(selected) * scrollView.frame.size.width) - scrollView.contentOffset.x)
        }
        else {
            //main view is centered (not scrolling)
            visibleWidth = scrollView.frame.width
        }
        var alpha = visibleWidth / scrollView.frame.width
        alpha = 2*alpha-1
        
        if let leftButton = self.navigationItem.leftBarButtonItem {
            if let tintColor = leftButton.tintColor {
                leftButton.tintColor = leftButton.tintColor.colorWithAlphaComponent(alpha)
            }
        }
        if let rightButton = self.navigationItem.rightBarButtonItem {
            if let tintColor = rightButton.tintColor {
                rightButton.tintColor = rightButton.tintColor.colorWithAlphaComponent(alpha)
            }
        }
    }
    
    func leftBarButtonItem(viewController: UIViewController) -> UIBarButtonItem? {
        if let viewController = viewController as? PASwipeViewControllerDataSource {
            return viewController.leftNavigationBarButton()
        }
        return nil
    }
    
    func rightBarButtonItem(viewController: UIViewController) -> UIBarButtonItem? {
        if let viewController = viewController as? PASwipeViewControllerDataSource {
            return viewController.rightNavigationBarButton()
        }
        return nil
    }
    
}
