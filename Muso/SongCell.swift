//
//  SongCell.swift
//  Muso
//
//  Created by Sergio Hernandez on 22/07/2017.
//  Copyright © 2017 Sergio Hernandez. All rights reserved.
//

import Foundation

class SongCell: UITableViewCell {
    
    let title = UILabel()
    let artists = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        title.font = UIFont(name: ".SFUIText-Semibold", size: 18)
        artists.font = UIFont(name: ".SFUIText-Light", size: 14)
        self.backgroundColor = #colorLiteral(red: 0.1000545993, green: 0.1480676532, blue: 0.2021201253, alpha: 1)
        self.tintColor = #colorLiteral(red: 0.1000545993, green: 0.1480676532, blue: 0.2021201253, alpha: 1)
        self.title.textColor = .white
        self.artists.textColor = .white
        title.translatesAutoresizingMaskIntoConstraints = false
        artists.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(title)
        contentView.addSubview(artists)
        
        let viewsDict = [
            "title" : title,
            "artists" : artists,
            ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[title]-2-[artists]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[title]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[artists]", options: [], metrics: nil, views: viewsDict))
    }
    
}
