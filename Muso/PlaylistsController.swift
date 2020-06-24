//
//  MusicMenuController.swift
//  Muso
//
//  Created by Sergio Hernandez on 15/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class PlaylistsController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Style
        self.tableView.separatorStyle = .none
        self.title = "Playlists"
        self.view.backgroundColor = #colorLiteral(red: 0.1000545993, green: 0.1480676532, blue: 0.2021201253, alpha: 1)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Get the user's playlists
        getUserPlaylists()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Activate scrolling in pages
        activateScrolling()
    }
    
    func getUserPlaylists() {
        SPTPlaylistList.playlists(forUser: Model.session.canonicalUsername, withAccessToken: Model.session.accessToken, callback: { (error, response) in
            if let listPage = response as? SPTPlaylistList, let serverPlaylists = listPage.items as? [SPTPartialPlaylist] {
                print("First Page of Playlists")
                Model.playlists.append(contentsOf: serverPlaylists)    // or however you want to parse these
                print("Playlist count = \(Model.playlists.count)")
                if listPage.hasNextPage {
                    self.getNextPlaylistPage(currentPage: listPage)
                }
                else {
                    print("Trying to reload cells")
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func getNextPlaylistPage(currentPage: SPTListPage) {
        print("Another Page of Playlists")
        currentPage.requestNextPage(withAccessToken: Model.session.accessToken, callback: { (error, response) in
            if let page = response as? SPTListPage, let serverPlaylists = page.items as? [SPTPartialPlaylist] {
                Model.playlists.append(contentsOf: serverPlaylists)     // or parse these beforehand, if you need/want to
                print("Playlist count = \(Model.playlists.count)")
                if page.hasNextPage {
                    self.getNextPlaylistPage(currentPage: page)
                }
                else {
                    print("Trying to reload cells")
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.playlists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath)
        // Configure Cell
        cell.textLabel?.text = Model.playlists[indexPath.row].name
        cell.textLabel?.textColor = .white

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        Model.selectedPlaylist = Model.playlists[indexPath.row]
        performSegue(withIdentifier: "PlaylistSelected", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
//            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Insert
        }
    }
    
    func activateScrolling() {
        for view in Model.pagesController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }
    
    
}
 
