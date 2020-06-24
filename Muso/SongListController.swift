//
//  SongListController.swift
//  Muso
//
//  Created by Sergio Hernandez on 15/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class SongListController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Style
        self.tableView.separatorStyle = .none
        self.view.backgroundColor = #colorLiteral(red: 0.1000545993, green: 0.1480676532, blue: 0.2021201253, alpha: 1)
        self.title = Model.selectedPlaylist.name
        self.navigationController?.navigationBar.backgroundColor = .black
        // Get the tracks
        let urlString =  Model.selectedPlaylist.uri.absoluteString
        let uri = URL(string: urlString)
        SPTPlaylistSnapshot.playlist(withURI: uri, accessToken: Model.session.accessToken!) { (error, snap) in
            if let s = snap as? SPTPlaylistSnapshot {
                // Empty previous tracks and save this playlist's ones
                Model.tracks = []
                for track in s.firstTrackPage.items {
                    if let thistrack = track as? SPTPlaylistTrack {
                        Model.tracks.append(thistrack)
                    }
                }
            }
            self.tableView.reloadData()
            print("Tracks Loaded: There are \(Model.tracks.count) tracks in this playlist")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Disable page scrolling
        removeScrolling()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(Model.selectedPlaylist.trackCount)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongCell
        // Configure Cell
        if (!Model.tracks.isEmpty && indexPath.row < Model.tracks.count) {
            cell.title.text = Model.tracks[indexPath.row].name
            cell.artists.text = formatArtists(artists: Model.tracks[indexPath.row].artists as! [SPTPartialArtist])
        }
        cell.textLabel?.textColor = .white
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Play song
        let selectedTrack = Model.tracks[indexPath.row]
        if !selectedTrack.isPlayable {
            // The track cannot be played (generally conexion issues)
            // This does not apply to local tracks
        } else if selectedTrack.identifier == nil {
            // It is a local track
        } else {
            // Play selected track
            let trackURLString = selectedTrack.playableUri.absoluteString
            Model.player.playSpotifyURI(trackURLString, startingWith: 0, startingWithPosition: 0, callback: { (error) in
                self.configureModelCurrentTrack(track: selectedTrack)
                print(Model.player)
                print(Model.player.playbackState)
                Model.playlistsNavigator.makeTrackButton()
                self.performSegue(withIdentifier: "ReproducePlaylistTrack", sender: self)
                if error != nil {
                    print("playing!")
                }
            })
        }
    }
    
    func configureModelCurrentTrack(track: SPTPlaylistTrack) {
        Model.currentTrackName = track.name
        Model.currentTrackAlbum = track.album.name
        Model.currentTrackCoverURL = track.album.largestCover.imageURL.absoluteString
        Model.currentTrackURL = track.playableUri.absoluteString
        Model.currentTrackArtists = []
        for artist in track.artists as! [SPTPartialArtist] {
            Model.currentTrackArtists.append(artist.name)
        }
    }
    
    func formatArtists(artists: [SPTPartialArtist]) -> String {
        var string = ""
        if artists.count > 0 {
            string = artists[0].name
        }
        for i in 1..<artists.count {
            string += ", \(artists[i].name!)" as String!
        }
        
        return string
    }
    
    func removeScrolling() {
        for view in Model.pagesController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = false
            }
        }
    }
    
//    func addTrackToQueue(track: SPTPlaylistTrack) {
//        let trackURLString = track.playableUri.absoluteString
//        player.queueSpotifyURI(trackURLString, callback: { (error) in
//            if error != nil {
//                print("Couldn't queue tracks: \(String(describing: error?.localizedDescription))")
//            }
//        })
//    }
}
