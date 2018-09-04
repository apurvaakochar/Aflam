//
//  MovieListInteractor.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import RealmSwift

class MovieListInteractor {
    var totalPages : Int?
    
    var currentPage : Int? {
        didSet{
            if currentPage! <= totalPages! {
                self.makeAPIRequest(at: String(currentPage!))
            }
        }
    }
    var searchText: String? {
        didSet {
            self.totalPages = 1
            self.currentPage = 1
            self.movies.removeAll()
        }
    }
    
    var movies = [Movie]()
    
    var cellVM = [Movie]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfRows: Int {
        return cellVM.count
    }
    
    func getCellViewModel(at index: IndexPath) -> Movie {
        return cellVM[index.row]
    }
    
    var reloadTableViewClosure: (()->())?
    func makeAPIRequest(at page: String) {
        let path = "http://api.themoviedb.org/3/search/movie?api_key=2696829a81b1b5827d515ff121700838"
        let parameters = ["query" : searchText!, "page" : page]
       
        ServerRequest().getRequest(path: path, parameters: parameters) {
            apiResult in
            guard let movieData = apiResult as? [String:Any] else{
                return
            }
            guard let results = movieData["results"] as? [[String:Any]] else {
                return
            }
            if !results.isEmpty {
                
                if self.currentPage == 1 {
                    self.totalPages = movieData["total_pages"] as? Int
                    let realm = try! Realm()
                    
                    let newLastSearch = self.makeLastSearch(self.searchText!)
                    let lastSearches = realm.objects(LastSearch.self)
                    
                    let searchList = lastSearches.map{
                        $0.name
                    }
                    
                    let count = realm.objects(LastSearch.self).count
                    
                    print(realm.objects(LastSearch.self).count)
                    if count == 10 {
                        if let firstSearch = realm.objects(LastSearch.self).first {
                                try! realm.write {
                                    realm.delete(firstSearch)
                                }
                        }
                    }
                    print(realm.objects(LastSearch.self).count)
                    try! realm.write {
                        realm.add(newLastSearch)
                    }
                    print(realm.objects(LastSearch.self).count)
                }
                
                
                for result in results {
                    self.movies.append(Movie(result))
                }
                self.cellVM = self.movies
            }
        }
    }
    
    func makeLastSearch(_ name: String) -> LastSearch {
        let newLastSearch = LastSearch()
        newLastSearch.name = name
        
        return newLastSearch
    }
    
}
