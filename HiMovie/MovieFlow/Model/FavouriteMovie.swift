//
//  FavouriteMovie.swift
//  HiMovie
//
//  Created by Max Kraev on 11/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteMovie: Object {
    
    @objc dynamic var id: Int = 0
    
    @objc dynamic var title: String = ""
    @objc dynamic var releaseDate: String = ""
    @objc dynamic var overview: String = ""
    @objc dynamic var imagePath: String = ""
    @objc dynamic var revenue: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
