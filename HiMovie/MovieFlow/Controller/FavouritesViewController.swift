//
//  FavouritesViewController.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import RealmSwift

class FavouritesViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    
    //MARK:- Vars
    
    let detailsSegueID = "showDetailFromFavourites"
    let favoriteCellID = "favouriteCell"
    
    var realm = try! Realm()
    
    var favouriteMovies: Results<FavoriteMovie>?
    var selectedMovie: FavoriteMovie?
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFavorites()
    }
    
    //MARK:- Public
    
    
    
    //MARK:- Private
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let width = UIScreen.main.bounds.width / 2 - 5
        let height = width * 1.8
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 5
    }
    
    private func getFavorites() {
        favouriteMovies = realm.objects(FavoriteMovie.self)
        collectionView.reloadData()
    }
    
    //MARK:- Actions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case detailsSegueID:
            guard let selectedMovie = selectedMovie else { return }
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.fromFavourites = true
            detailVC.movieID = selectedMovie.id
        default:
            return
        }
    }

}

extension FavouritesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMovie = favouriteMovies?[indexPath.item]
        performSegue(withIdentifier: detailsSegueID, sender: self)
    }
}

extension FavouritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouriteMovies?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellID, for: indexPath) as! FavouriteMovieCell
        
        guard let movies = favouriteMovies else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: favoriteCellID, for: indexPath)
        }
        
        cell.configure(with: movies, at: indexPath)
        
        return cell
    }
    
    
}
