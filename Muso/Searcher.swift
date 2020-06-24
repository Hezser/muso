//
//  Searcher.swift
//  Muso
//
//  Created by Sergio Hernandez on 20/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class Searcher: UITableViewController, UISearchResultsUpdating {
    
    var searchController : UISearchController!
    var resultsController = UITableViewController()
    var request: URLRequest!
    var results = [SPTPartialTrack]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.resultsController.tableView.dataSource = self
        self.resultsController.tableView.delegate = self
        self.searchController = UISearchController(searchResultsController: self.resultsController)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        view.layer.cornerRadius = 7
        self.tableView.separatorStyle = .none
        self.title = "Search"
        self.view.backgroundColor = #colorLiteral(red: 0.1000545993, green: 0.1480676532, blue: 0.2021201253, alpha: 1)
        self.resultsController.tableView.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Activate scrolling in pages
        activateScrolling()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // Filter through the results
        results = []
    
        let search = self.searchController.searchBar.text!
        SPTSearch.perform(withQuery: search, queryType: .queryTypeTrack, accessToken: Model.session.accessToken, callback: { (error, result) -> Void in
            if error == nil {
                let listPage = result as! SPTListPage
                if listPage.items != nil {
                    self.results = listPage.items as! [SPTPartialTrack]
                    print("I loaded")
                    print(self.results)
                    // Update the results TableView
                    print("I will update")
                    self.resultsController.tableView.reloadData()
                }
            } else {
                print("There was an error when searching: \(String(describing: error?.localizedDescription))")
            }
        })
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.tableView {
            print("IM HERE")
            if (self.results.count > 30) {
                print("I returned 30")
                return 30
            } else {
                print("I returned \(self.results.count)")
                return self.results.count
            }
        } else {
            print("IM HERE FOR SOME REASON")
            if (self.results.count > 30) {
                print("I returned 30")
                return 30
            } else {
                print("I returned \(self.results.count)")
                return self.results.count
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = SongCell()
        let cell = UITableViewCell()
        
        if tableView == self.tableView {
            cell.textLabel?.text = results[indexPath.row].name
//            cell.title.text = results[indexPath.row].name
//            cell.artists.text = formatArtists(artists: results[indexPath.row].artists as! [SPTPartialArtist])
        } else {
            cell.textLabel?.text = results[indexPath.row].name
//            cell.title.text = results[indexPath.row].name
//            cell.artists.text = formatArtists(artists: results[indexPath.row].artists as! [SPTPartialArtist])
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Create queue of tracks in Model

        // Selected a result
        let track = results[indexPath.row]
        configureModelCurrentTrack(track: track)
        print(Model.currentTrackURL)
        play(trackURL: Model.currentTrackURL)
    }
    
    func tableView(tableView: UITableView,
                         heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func configureModelCurrentTrack(track: SPTPartialTrack) {
        Model.currentTrackName = track.name
        Model.currentTrackAlbum = track.album.name
        Model.currentTrackCoverURL = track.album.largestCover.imageURL.absoluteString
        Model.currentTrackURL = track.playableUri.absoluteString
        Model.currentTrackArtists = []
        for artist in track.artists as! [SPTPartialArtist] {
            Model.currentTrackArtists.append(artist.name)
        }
        print(Model.player)
        print(Model.player.playbackState)
    }
    
    func play(trackURL: String) {
        // Play selected track
        Model.player.playSpotifyURI(trackURL, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            print(Model.player)
            print(Model.player.playbackState)
            Model.searchNavigator.makeTrackButton()
            self.performSegue(withIdentifier: "ReproduceSearchedTrack", sender: self)
            if error != nil {
                print("playing!")
            }
        })
    }
    
    func formatArtists(artists: [SPTPartialArtist]) -> String {
        var string = ""
        if artists.count > 0 {
            string = artists[0].name
        }
        for i in 1..<artists.count {
            string += ", \(artists[i].name)" as String
        }
        
        return string
    }
    
    func activateScrolling() {
        for view in Model.pagesController.view.subviews {
            if let subView = view as? UIScrollView {
                subView.isScrollEnabled = true
            }
        }
    }
    
//    // Delete by swipping
//    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
    
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // Update the dictionary
//            let i = CasePageModel.procedures.keys.index(of: tableView.cellForRow(at: indexPath)!.textLabel!.text!)
//            CasePageModel.procedures.remove(at: i!)
//            // Update the array
//            let j = CasePageModel.proceduresArray.index(of: tableView.cellForRow(at: indexPath)!.textLabel!.text!)
//            CasePageModel.proceduresArray.remove(at: j!)
//            self.tableView.reloadData()
//        }
//    }
}
