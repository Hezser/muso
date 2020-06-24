//
//  YourMusicTabController.swift
//  Muso
//
//  Created by Sergio Hernandez on 24/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class MusicTabController: UITabBarController, UITabBarControllerDelegate {
    
    @IBOutlet weak var bar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        self.title = "Music"
        // Position the bar at the top
        UIApplication.shared.statusBarFrame.size.height
        bar.frame = CGRect(x: 0, y:  bar.frame.size.height, width: bar.frame.size.width, height: bar.frame.size.height)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let playlists = PlaylistsController()
        let playlistsIcon = UITabBarItem(title: "Your Music", image: UIImage(named: "icons8-Heart-100"), selectedImage: UIImage(named: "icons8-Heart-100"))
        playlists.tabBarItem = playlistsIcon
        let discover = PlaylistsController()
        let discoverIcon = UITabBarItem(title: "Discover", image: UIImage(named: "icons8-Music Record-100"), selectedImage: UIImage(named: "icons8-Music Record-100"))
        discover.tabBarItem = discoverIcon
        let controllers = [playlists, discover]
        self.viewControllers = controllers
    }
    
    // Delegate methods
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("Should select viewController: \(viewController.title) ?")
        return true;
    }
}
