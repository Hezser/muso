//
//  Navigator.swift
//  Muso
//
//  Created by Sergio Hernandez on 15/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class Navigator: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavigationBarHidden(false, animated: true)
        self.view.backgroundColor = #colorLiteral(red: 0.04242696613, green: 0.06250169128, blue: 0.07918072492, alpha: 1)
        self.navigationBar.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.06274509804, blue: 0.07843137255, alpha: 1)
        self.navigationBar.barTintColor = #colorLiteral(red: 0.04242696613, green: 0.06250169128, blue: 0.07918072492, alpha: 1)
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        if self.topViewController is PlaylistsController {
            Model.playlistsNavigator = self
        } else if self.topViewController is Searcher {
            Model.searchNavigator = self
        }
    }
    
    func makeTrackButton() {
        let currentSongBarButton = UIBarButtonItem(title: "♪", style: .plain, target: self, action: #selector(goToPlayer))
        self.navigationItem.setRightBarButton(currentSongBarButton, animated: true)
        self.navigationItem.rightBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName: #colorLiteral(red: 0.802159965, green: 0.5399996638, blue: 0.1291772127, alpha: 1)], for: UIControlState.normal)
        print("Bar Button Made")
    }
    
    func deleteTrackButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    func goToPlayer() {
        // Maybe need to change "toReproducePlaylistTrack" depeneding on something
        performSegue(withIdentifier: "ReproduceSearchedTrack", sender: self)
    }
}
