//
//  MovieDetailViewController.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class MovieDetailViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseDateLabel: UILabel!
    @IBOutlet weak var movieRevenueLabel: UILabel!
    
    @IBOutlet weak var movieOverviewLabel: UILabel!
    
    
    //MARK:- Vars
    
    var realm = try! Realm()
    
    var movieID: Int = 0
    var fromFavourites: Bool = false
    
    var detailsFromServer: MovieDetail?
    var detailsFromRealm: [FavoriteMovie]?
    
    var networkManager = MovieNetworkManager()
    
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkState()
    }
    
    //MARK:- Private
    
    private func checkState() {
        if fromFavourites {
            setupRemoveNavigationItem()
            loadDetailsFromRealm()
        } else {
            setupAddNavigationItem()
            loadDetailsFromServer()
        }
    }
    
    private func setupAddNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addToRealm))
    }
    
    private func setupRemoveNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeFromRealm))
    }
    
    private func loadDetailsFromServer() {
        SVProgressHUD.show()
        
        guard movieID != 0 else { return }
        
        networkManager.getMovieDetails(by: movieID) {[weak self] (details, error) in
            guard error == nil, let details = details else {
                SVProgressHUD.showError(withStatus: "Could not load details")
                SVProgressHUD.dismiss(withDelay: 1)
                print(error as Any)
                return
            }
            self?.detailsFromServer = details
            DispatchQueue.main.async {
                self?.updateUI(with: details)
                SVProgressHUD.dismiss()
            }
        }
    }
    
    private func loadDetailsFromRealm() {
        guard let movie = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieID) else { return }
        updateUI(with: movie)
    }
    
    private func updateUI(with details: MovieDetail) {
        let url = networkManager.imageServerURL + details.posterPath
        movieImageView.downloadFrom(url: url)
        movieTitleLabel.text = details.title
        movieOverviewLabel.text = details.overview
        movieRevenueLabel.text = "$\(details.revenue)"
        movieReleaseDateLabel.text = details.releaseDate
    }
    
    private func updateUI(with details: FavoriteMovie) {
        
        if let imageURLPath = URL(string: details.imagePath)?.path {
            movieImageView.image = UIImage(contentsOfFile: imageURLPath)
        }
        
        movieTitleLabel.text = details.title
        movieOverviewLabel.text = details.overview
        movieRevenueLabel.text = "$\(details.revenue)"
        movieReleaseDateLabel.text = details.releaseDate
    }
    
    private func saveImageAndGetPath() -> String? {
        do {
            let image = movieImageView.image?.jpegData(compressionQuality: 1)
            let docDir = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            
            let imageURL = docDir.appendingPathComponent(detailsFromServer?.posterPath ?? "tmp.jpg")
            try image?.write(to: imageURL)
            
            return imageURL.absoluteString
            
        } catch {
            print(error)
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay: 1)
            return nil
        }
        
    }
    
    //MARK:- Actions
    
    @objc private func addToRealm() {
        
        do {
            guard let imagePath = saveImageAndGetPath() else {
                SVProgressHUD.showError(withStatus: "Can't save image")
                return
            }
            
            try realm.write {
                let favMovie = FavoriteMovie()
                favMovie.imagePath = imagePath
                
                favMovie.id = movieID
                favMovie.overview = movieOverviewLabel.text!
                favMovie.releaseDate = movieReleaseDateLabel.text!
                favMovie.revenue = movieRevenueLabel.text!
                favMovie.title = movieTitleLabel.text!
                
                if let _ = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieID) {
                    SVProgressHUD.show(withStatus: "Already in favorites!")
                    SVProgressHUD.dismiss(withDelay: 1)
                    return
                }
                
                realm.add(favMovie)
                SVProgressHUD.showSuccess(withStatus: "Added to Favourites!")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
        setupRemoveNavigationItem()
        
    }
    
    @objc private func removeFromRealm() {
        
        guard let object = realm.object(ofType: FavoriteMovie.self, forPrimaryKey: movieID) else { return }
        
        //Remove items from file manager
        guard let url = URL(string: object.imagePath) else { return }
        print(url)
        let path = url.path
        if FileManager.default.fileExists(atPath: path) {
            try? FileManager.default.removeItem(at: url)
        }
        
        //Remove items from Realm
        
        do {
            try realm.write {
                realm.delete(object)
                SVProgressHUD.showSuccess(withStatus: "Removed from Favourites!")
                SVProgressHUD.dismiss(withDelay: 1)
            }
        } catch {
            SVProgressHUD.showError(withStatus: error.localizedDescription)
            SVProgressHUD.dismiss(withDelay: 1)
        }
        
        setupAddNavigationItem()
        
    }
    
    

}
