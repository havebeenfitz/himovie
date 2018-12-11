//
//  MovieCell.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateCreatedLabel: UILabel!
    
    
    //MARK:- Vars
    
    private let imageServerUrl = MovieNetworkManager().imageServerURL
    
    func configure(with query: [Result], at indexPath: IndexPath) {
        self.movieTitleLabel.text = query[indexPath.item].title
        self.movieDateCreatedLabel.text = query[indexPath.item].releaseDate
    
        let url = imageServerUrl + (query[indexPath.item].posterPath ?? "")
        
        self.movieImageView.downloadFrom(url: url)
    }
    
}
