PASwipeViewController
===================

This is a simple subclass of UIViewController reproducing the behaviour of the Twitter iOS app. It handles the swipe between multiple viewControllers, and synchronise swipe of titles and apparition of navbar buttons. 

![demo_gif](https://raw.githubusercontent.com/philippeauriach/PASwipeViewController/master/demo.gif?id=1 "Demo")

----------
Usage
-------------
The repo contains a functional example, but basically add the **PASwipeViewController.swift** file to your project, and then instantiate it this way: 
```swift
let swipeVC = PASwipeViewController(viewControllers: viewControllers)
        
let navVC = UINavigationController(rootViewController: swipeVC)
        
window = UIWindow(frame: UIScreen.mainScreen().bounds)
if let window = window {
  window.backgroundColor = UIColor.whiteColor()
  window.makeKeyAndVisible()
  window.rootViewController = navVC
}
```
If you specify the optional property "title" on your viewControllers, it will be displayed in the navbar.

If you want to provide buttons in the navbar, make your inside controller implement **PASwipeViewControllerDataSource** and the following methods:
```swift
  func leftNavigationBarButton() -> UIBarButtonItem?
  func rightNavigationBarButton() -> UIBarButtonItem?
```
This will make the buttons appears and disappears when the views are scrolled.

Finally, you can be notified of changed page by either implementing the **PASwipeViewControllerDelegate** or using the block syntax:
```swift
swipeVC.onSwipeViewDidSwipe = { (selectedIndex:Int, selectedViewController:UIViewController) -> Void in
  println("changed to \(selectedIndex)")
}
``` 
