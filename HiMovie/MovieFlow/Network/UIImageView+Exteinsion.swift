//
//  UIImage+Exteinsion.swift
//  HiMovie
//
//  Created by Max Kraev on 10/12/2018.
//  Copyright © 2018 Max Kraev. All rights reserved.
//

import UIKit
import Alamofire

extension UIImageView {
    
    func downloadFrom(url: URLConvertible) {
        self.image = #imageLiteral(resourceName: "placeholder")
        
        let indicator = UIActivityIndicatorView(style: .gray)
        self.addSubview(indicator)
        indicator.center = self.center
        
        indicator.startAnimating()
        Alamofire.request(url).response { (response) in
            guard response.error == nil, let data = response.data else {
                self.image = #imageLiteral(resourceName: "placeholder")
                indicator.stopAnimating()
                return
            }
            self.image = UIImage(data: data)
            indicator.stopAnimating()
        }
    }
    
}

