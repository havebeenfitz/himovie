//
//  MovieDetail.swift
//  HiMovie
//
//  Created by Max Kraev on 11/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    let id: Int
    let overview: String
    let posterPath: String

    let releaseDate: String
    let revenue: Int

    let title: String
    
    enum CodingKeys: String, CodingKey {
        case overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case revenue
        case title
        case id
    }
}
