//
//  MovieNetworkManager.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation
import Alamofire

class MovieNetworkManager {
    
    public let imageServerURL = "https://image.tmdb.org/t/p/w300"
    
    private let urlSession = URLSession(configuration: .default)
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let apiKey = "d1e9026c62287d36cade487aff58d9ce"
    
    public func getSearchQuery(with text: String,
                               page: Int? = 1,
                               completion: @escaping (MovieQuery?, Error?) -> Void) {
        
        let url = baseURL + "/search/movie"
        let parameters: Parameters = ["api_key": apiKey,
                                      "query": text,
                                      "page": page ?? 1]
   
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    completion(nil, NSError(domain: "domain", code: 1, userInfo: ["Error": "could not get data"]))
                    return
                }
                
                do {
                    let movieQuery = try JSONDecoder().decode(MovieQuery.self, from: data)
                    completion(movieQuery, nil)
                } catch {
                    completion(nil, error)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
        
        
    }
    
    func getPopularMovies(page: Int? = 1,
                          completion: @escaping (MovieQuery?, Error?) -> Void) {
        
        let url = baseURL + "/movie/popular"
        let parameters: Parameters = ["api_key": apiKey,
                                      "page": page ?? 1]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    completion(nil, NSError(domain: "domain", code: 1, userInfo: ["Error": "could not get data"]))
                    return
                }
                
                do {
                    let movieQuery = try JSONDecoder().decode(MovieQuery.self, from: data)
                    completion(movieQuery, nil)
                } catch {
                    completion(nil, error)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
        
    }
    
    func getMovieDetails(by id: Int,
                         completion: @escaping (MovieDetail?, Error?) -> Void) {
        
        let url = baseURL + "/movie/" + String(id)
        let parameters: Parameters = ["api_key": apiKey]
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success(_):
                guard let data = response.data else {
                    completion(nil, NSError(domain: "domain", code: 1, userInfo: ["Error": "could not get data"]))
                    return
                }
                
                do {
                    let movieDetailQuery = try JSONDecoder().decode(MovieDetail.self, from: data)
                    completion(movieDetailQuery, nil)
                } catch {
                    completion(nil, error)
                }
                
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
}

