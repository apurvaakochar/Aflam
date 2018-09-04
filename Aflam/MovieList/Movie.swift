//
//  Movie.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation

struct Movie {
    var posterUrl: URL?
    var date: String?
    var name: String?
    var overview: String?
    
    init(_ movieData: [String:Any]) {
        if let urlSuffix = movieData["poster_path"] as? String{
            let url = String(format: Path.POSTER_PREFIX, urlSuffix)
            self.posterUrl = URL(string: url)
        }
        
        self.date = movieData["release_date"] as? String
        self.overview = movieData["overview"] as? String
        self.name = movieData["title"] as? String
    }
}
