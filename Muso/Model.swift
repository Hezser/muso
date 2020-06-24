//
//  Model.swift
//  Muso
//
//  Created by Sergio Hernandez on 16/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import UIKit
import Alamofire

class Model {
    
    static var player: SPTAudioStreamingController!
    static var session: SPTSession!
    
    static var currentTrackArtists: [String]!
    static var currentTrackAlbum: String!
    static var currentTrackName: String!
    static var currentTrackURL: String!
    static var currentTrackCoverURL: String!

    static var nextTrackArtists: [String]!
    static var nextTrackAlbum: String!
    static var nextTrackName: String!
    static var nextTrackURL: String!
    static var nextTrackCoverURL: String!

    static var previousTrackArtists: [String]!
    static var previousTrackAlbum: String!
    static var previousTrackName: String!
    static var previousTrackURL: String!
    static var previousTrackCoverURL: String!

    static var tracks = [SPTPlaylistTrack]()
    static var playlists = [SPTPartialPlaylist]()
    static var selectedPlaylist: SPTPartialPlaylist!
    static var playlistsNavigator: Navigator!
    static var searchNavigator: Navigator!
    static var pagesController: PagesController!

}
