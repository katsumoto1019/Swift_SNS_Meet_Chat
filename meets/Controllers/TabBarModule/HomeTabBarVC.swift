//
//  HomeTabBarVC.swift
//  DatingKinky
//
//  Created by Ubuntu on 7/24/20.
//  Copyright © 2020 Ubuntu. All rights reserved.
//

import UIKit
import TransitionableTab

class HomeTabBarVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        let attributes = [NSAttributedString.Key.font: UIFont(name: "TrueMegaMaru-Ultra", size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        /*if let count = self.tabBar.items?.count {
            
            /*self.tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_people_title") ?? UIColor.darkGray], for: .normal)
            self.tabBar.items![1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_people_title") ?? UIColor.darkGray], for: .selected)*/
            
            /*self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)], for: .normal)
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 21)], for: .selected)*/
            
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_plus_title") ?? UIColor.darkGray], for: .normal)
            
            self.tabBar.items![3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.init(named: "color_plus_title") ?? UIColor.darkGray], for: .selected)
           
            
            // set red as selected background color
//            let numberOfItems = CGFloat(tabBar.items!.count)
//            let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
//
//            tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
//
//            // remove default border
//            tabBar.frame.size.width = self.view.frame.width + 4
//            tabBar.frame.origin.x = -2
        }*/
    }
     
   /*func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        //print("\nIn  >  MyTabBarViewController  >  tabBarController() ..................................9-9-9-9-9\n\n")
       
        if viewController is PlusVC {
            print("Tab One Pressed")
            let numberOfItems = CGFloat(tabBar.items!.count)
            let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
            self.tabBar.backgroundImage = UIImage.imageWithColor(color: UIColor.white, size: tabBarItemSize).resizableImage(withCapInsets: UIEdgeInsets.zero)
        }
    }*/
}

// MARK: - TransitionableTab Protocols
extension HomeTabBarVC: TransitionableTab {
    
    func transitionDuration() -> CFTimeInterval {
        return 0.3
    }
    
    func transitionTimingFunction() -> CAMediaTimingFunction {
        return .easeInOut
    }
    
    func fromTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.from, direction: direction)
    }
    
    func toTransitionAnimation(layer: CALayer?, direction: Direction) -> CAAnimation {
        return DefineAnimation.move(.to, direction: direction)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
