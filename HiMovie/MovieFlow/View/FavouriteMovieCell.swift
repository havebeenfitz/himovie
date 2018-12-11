//
//  FavouriteMovieCell.swift
//  HiMovie
//
//  Created by Max Kraev on 11/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import RealmSwift

class FavouriteMovieCell: UICollectionViewCell {
    
    //MARK:- Outlets
    
    @IBOutlet weak var favouriteMovieImageView: UIImageView!
    @IBOutlet weak var favouriteMovieTitleLabel: UILabel!
    @IBOutlet weak var favouriteMovieReleaseDate: UILabel!
    
    
    func configure(with results: Results<FavoriteMovie>, at indexPath: IndexPath) {
        
        let imageURLPath = URL(string: results[indexPath.item].imagePath)?.path
       
        favouriteMovieImageView.image = UIImage(contentsOfFile: imageURLPath ?? "")
        favouriteMovieTitleLabel.text = results[indexPath.item].title
        favouriteMovieReleaseDate.text = results[indexPath.item].releaseDate
    }
    
}
