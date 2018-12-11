//
//  MoviesViewController.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import SVProgressHUD

class MoviesViewController: UIViewController {

    //MARK:- Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK:- Vars
    
    let movieCellID = "movieCell"
    let showDetailsSegueID = "showDetail"
    
    var popularMovies: [Result]?
    var filteredMovies: [Result]?
    
    let movieNetworkManager = MovieNetworkManager()
    var searchBarText: String = ""
    var page: Int = 1
    var totalPages: Int = 0
    
    var selectedMovieID: Int = 0
    
    //MARK:- LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupSearchController()
        
        getPopular()
    }
    
    //MARK:- Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case showDetailsSegueID:
            let detailVC = segue.destination as! MovieDetailViewController
            detailVC.movieID = selectedMovieID
        default:
            return
        }
    }
    
    //MARK:- Private
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let width = UIScreen.main.bounds.width / 2 - 5
        let height = width * 1.8
        
        flowLayout.itemSize = CGSize(width: width, height: height)
        flowLayout.minimumInteritemSpacing = 5
    }
    
    private func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        
        navigationItem.searchController = searchController
    }
    
    private func getPopular() {
        SVProgressHUD.show()
        movieNetworkManager.getPopularMovies { [weak self] (query, error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            self?.totalPages = query?.totalPages ?? 0
            self?.popularMovies = query?.results ?? []
            
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                SVProgressHUD.dismiss()
            }
            
        }
    }

}

extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let filteredMovies = filteredMovies {
            selectedMovieID = filteredMovies[indexPath.item].id
        } else {
            selectedMovieID = popularMovies?[indexPath.item].id ?? 0
        }
        performSegue(withIdentifier: showDetailsSegueID, sender: self)
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let filteredMovies = filteredMovies {
            return filteredMovies.count
        } else {
            return popularMovies?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let filteredMovies = filteredMovies {
            if (indexPath.item == filteredMovies.count - 1) && (page < totalPages) {
                page += 1
                movieNetworkManager.getSearchQuery(with: searchBarText, page: page) {[weak self] (query, error) in
                    guard error == nil, let query = query else { return }
                    self?.filteredMovies?.append(contentsOf: query.results)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        } else if let popularMovies = popularMovies {
            if (indexPath.item == popularMovies.count - 1) && (page < totalPages) {
                page += 1
                movieNetworkManager.getPopularMovies(page: page) {[weak self] (query, error) in
                    guard error == nil, let query = query else { return }
                    self?.popularMovies?.append(contentsOf: query.results)
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: movieCellID, for: indexPath) as! MovieCell
        
        if let filteledMovies = filteredMovies {
            cell.configure(with: filteledMovies, at: indexPath)
        } else if let popularMovies = popularMovies {
            cell.configure(with: popularMovies, at: indexPath)
        }
        
        return cell
    }
    
    
    
    
}

extension MoviesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBarText = searchBar.text!
        movieNetworkManager.getSearchQuery(with: searchBar.text!) { [weak self] (query, error) in
            guard let movieQuery = query else { return }
            self?.filteredMovies = movieQuery.results
            self?.totalPages = movieQuery.totalPages
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredMovies = nil
        popularMovies = nil
        totalPages = 0
        page = 1
        getPopular()
    }
}


