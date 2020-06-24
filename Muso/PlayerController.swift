//
//  PlayerController.swift
//  Muso
//
//  Created by Sergio Hernandez on 15/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class PlayerController: UIViewController {
    
    @IBOutlet weak var coverView: UIImageView!
    var currentTrack: SPTPlaylistTrack!
    var nextTrack: SPTPlaylistTrack!
    var previousTrack: SPTPlaylistTrack!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        // General Configuration
        configureForCurrentTrack()
    //// Set recognizers
        coverView.isUserInteractionEnabled = true
        // Set tap recognizer
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.addTarget(self, action: #selector(PlayerController.interfaceHasBeenTapped))
        // Set double-tap recognizer
        let doubleTapRecognizer = UITapGestureRecognizer()
        doubleTapRecognizer.numberOfTapsRequired = 2
        doubleTapRecognizer.addTarget(self, action: #selector(PlayerController.interfaceHasBeenDoubleTapped))
        // Configure both tap recognizers
        tapRecognizer.require(toFail: doubleTapRecognizer)
        tapRecognizer.delaysTouchesBegan = true
        doubleTapRecognizer.delaysTouchesBegan = true
        coverView.addGestureRecognizer(tapRecognizer)
        coverView.addGestureRecognizer(doubleTapRecognizer)
        // Set right swipe recognizer
        let swipeRightRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayerController.interfaceHasBeenSwippedRight))
        swipeRightRecognizer.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRightRecognizer)
        // Set left swipe recognizer
        let swipeLeftRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayerController.interfaceHasBeenSwippedLeft))
        swipeLeftRecognizer.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeftRecognizer)
        // Set up swipe recognizer
        let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayerController.interfaceHasBeenSwippedUp))
        swipeUpRecognizer.direction = UISwipeGestureRecognizerDirection.up
        self.view.addGestureRecognizer(swipeUpRecognizer)
        // Set down swipe recognizer
        let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(PlayerController.interfaceHasBeenSwippedDown))
        swipeDownRecognizer.direction = UISwipeGestureRecognizerDirection.down
        self.view.addGestureRecognizer(swipeDownRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Disable page scrolling
        removeScrolling()
    }
    
    func configureForCurrentTrack() {
        self.title = Model.currentTrackName
        // Queue next/shuffle track
        if Model.player.playbackState.isShuffling {
            queueSuffleTrack()
        } else {
            queueNextTrack()
        }
        // Set track's album image
        let url = URL(string: Model.currentTrackCoverURL)
        let data = try? Data(contentsOf: url!)
        let cover = UIImage(data: data!)
        coverView.image = cover
    }
    
    func play(trackURL: String) {
        Model.player.playSpotifyURI(trackURL, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            if error != nil {
                print("playing!")
            }
        })
    }
    
    func queueSuffleTrack() {
        if (Model.tracks.count < 2) {
            return
        }
        let index = Int(arc4random_uniform(UInt32(Model.tracks.count)))
        nextTrack = Model.tracks[index]
    }
    
    func queueNextTrack() {
        if (Model.tracks.count < 2) {
            return
        }
        var index = searchIndex(of: Model.currentTrackURL, within: Model.tracks) + 1
        print(index)
        if index >= Model.tracks.count {
            index = 0
        }
        nextTrack = Model.tracks[index]
    }
    
    func searchIndex(of trackURL: String, within list: [SPTPlaylistTrack]) -> Int {
        var index = 0
        for track in list {
            if track.identifier == nil {
                index += 1
                continue
            }
            if track.playableUri.absoluteString == trackURL {
                print(index)
                return index
            }
            index += 1
        }
        print("fuck")
        return -1
    }
    
    func configureModelNextTrack(track: SPTPlaylistTrack) {
        Model.nextTrackAlbum = track.album.name
        Model.nextTrackURL = track.uri.absoluteString
        Model.nextTrackName = track.name
        Model.nextTrackCoverURL = track.album.largestCover.imageURL.absoluteString
        Model.nextTrackArtists = []
        for artist in track.artists as! [SPTPartialArtist] {
            Model.nextTrackArtists.append(artist.name)
        }
    }
    
    func configureModelPreviousTrack(track: SPTPlaylistTrack) {
        Model.previousTrackAlbum = track.album.name
        Model.previousTrackURL = track.uri.absoluteString
        Model.previousTrackName = track.name
        Model.previousTrackCoverURL = track.album.largestCover.imageURL.absoluteString
        Model.previousTrackArtists = []
        for artist in track.artists as! [SPTPartialArtist] {
            Model.previousTrackArtists.append(artist.name)
        }
    }
    
    func configureModelCurrentTrack(track: SPTPlaylistTrack) {
        Model.currentTrackAlbum = track.album.name
        Model.currentTrackURL = track.uri.absoluteString
        Model.currentTrackName = track.name
        Model.currentTrackCoverURL = track.album.largestCover.imageURL.absoluteString
        Model.currentTrackArtists = []
        for artist in track.artists as! [SPTPartialArtist] {
            Model.currentTrackArtists.append(artist.name)
        }
    }
    
    func removeScrolling() {
        for view in Model.pagesController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
    func interfaceHasBeenTapped() {
        if Model.player.playbackState.isPlaying {
           Model.player.setIsPlaying(false, callback: nil)
           Model.playlistsNavigator.deleteTrackButton()
        } else {
           Model.player.setIsPlaying(true, callback: nil)
           Model.playlistsNavigator.makeTrackButton()
        }
    }
    
    func interfaceHasBeenDoubleTapped() {
        if Model.player.playbackState.isShuffling {
           Model.player.setShuffle(false, callback: nil)
           queueNextTrack()
           print("Shuffe Off")
        } else {
           Model.player.setShuffle(true, callback: nil)
           queueSuffleTrack()
           print("Shuffe On")
        }
    }
    
    func interfaceHasBeenSwippedRight() {
        // Only works once per track because there is not a recording of the last (let's say) 10 played songs, just the one before. Thus: need to create queue of last played songs for this to work. It would be good as well to create a queue pf upcommign songs, because even if it works this way, you may want to show the user the queue at some point.
        if Model.previousTrackURL != nil {
            let aux = currentTrack
            currentTrack = previousTrack
            nextTrack = aux
            configureModelCurrentTrack(track: currentTrack)
            configureModelNextTrack(track: nextTrack)
            play(trackURL: Model.currentTrackURL)
            configureForCurrentTrack()
            print("Next Track: \(Model.currentTrackName)")
        }
    }
    
    func interfaceHasBeenSwippedLeft() {
        if nextTrack != nil {
            let aux = currentTrack
            currentTrack = nextTrack
            previousTrack = aux
            configureModelCurrentTrack(track: currentTrack)
            configureModelPreviousTrack(track: previousTrack)
            play(trackURL: Model.currentTrackURL)
            configureForCurrentTrack()
            print("Next Track: \(Model.currentTrackName)")
        }
    }
    
    func interfaceHasBeenSwippedUp() {
        // What?
    }
    
    func interfaceHasBeenSwippedDown() {
        // What?
    }
    
}
