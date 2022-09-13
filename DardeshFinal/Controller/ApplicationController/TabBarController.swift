//
//  TabBarController.swift
//  DardeshFinal
//
//  Created by MacOS on 28/01/2022.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setTabBarController()
    }
    
    func setTabBarController(){
        
        
        let FVC = UINavigationController(rootViewController: ChatTVC())
        let SVC = UINavigationController(rootViewController:ChannelsVC())
        let TVC = UINavigationController(rootViewController:UsersTVC())
        let LastVC = UINavigationController(rootViewController:SettingsTVC())
        
        FVC.title = "Chat"
        SVC.title = "Channels"
        TVC.title = "Users"
        LastVC.title = "Settings"
       
        FVC.tabBarItem.image = UIImage(systemName: "message")
        SVC.tabBarItem.image = UIImage(systemName: "quote.bubble")
        TVC.tabBarItem.image = UIImage(systemName: "person.2")
        LastVC.tabBarItem.image = UIImage(systemName: "gear")
        
        
        viewControllers = [FVC,SVC,TVC,LastVC]
        selectedIndex = 3
        tabBar.backgroundColor = .white
     
    }
    
    
}
