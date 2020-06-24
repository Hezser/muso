//
//  ViewController.swift
//  Muso
//
//  Created by Sergio Hernandez on 15/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit

class LogInController: UIViewController, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var auth = SPTAuth.defaultInstance()!
    var session: SPTSession!
    var player: SPTAudioStreamingController?
    var loginUrl: URL?
    @IBOutlet weak var loginButton: UIButton!
    
    func setup() {
        print("Setting up")
        SPTAuth.defaultInstance().clientID = "3b3d7a47956945099b40a2856c4408f0"
        SPTAuth.defaultInstance().redirectURL = URL(string: "muso-login://returnAfterLogin")
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope, SPTAuthPlaylistReadPrivateScope, SPTAuthPlaylistModifyPrivateScope, SPTAuthPlaylistModifyPublicScope, SPTAuthPlaylistReadCollaborativeScope]
        loginUrl = SPTAuth.defaultInstance().spotifyWebAuthenticationURL()
    }
    

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        print("Login Button Was Pressed")
        if UIApplication.shared.openURL(loginUrl!) {
            if auth.canHandle(auth.redirectURL) {
                // To do - build in error handling
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 15
        loginButton.clipsToBounds = true
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAfterFirstLogin), name: Notification.Name("loginSuccessfull"), object: nil)
        print("Finsished Loading")
    }
    
    func updateAfterFirstLogin() {
        print("Updating After First Login")
        let userDefaults = UserDefaults.standard
        if let sessionObj:AnyObject = userDefaults.object(forKey: "SpotifySession") as AnyObject? {
            let sessionDataObj = sessionObj as! Data
            let firstTimeSession = NSKeyedUnarchiver.unarchiveObject(with: sessionDataObj) as! SPTSession
            self.session = firstTimeSession
            initializePlayer(authSession: session)
        }
        Model.session = session
    }
    
    func initializePlayer(authSession: SPTSession) {
        print("Initianising Player")
        if self.player == nil {
            self.player = SPTAudioStreamingController.sharedInstance()
            self.player!.playbackDelegate = self
            self.player!.delegate = self
            try! player!.start(withClientId: auth.clientID)
            self.player!.login(withAccessToken: authSession.accessToken)
        }
        Model.player = player
    }
    
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        // After a user authenticates a session, the SPTAudioStreamingController is then initialized and this method called
        print("Logged in")
        performSegue(withIdentifier: "LoggedIn", sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

