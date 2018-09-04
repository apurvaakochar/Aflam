//
//  MovieListInteractor.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import RealmSwift

protocol MovieListBusinessLogic {
    var currentPage : Int? {get set}
    var searchText: String? {get set}
}

protocol MovieListPresentationLogic {
    var numberOfRows: Int {get}
    var reloadTableViewClosure: (()->())? {get set}
    func getCellViewModel(at index: IndexPath) -> Movie
}

class MovieListInteractor: MovieListBusinessLogic, MovieListPresentationLogic {
    // MARK: - Properties
    
    /*
     Total number of pages that a search result has
    */
    private var totalPages : Int?
    /*
     Store the movies and append it according to the current page
     */
    private var movies = [Movie]()
    /*
     Cell View Model and when it set, the table view is reloaded with the closure
     */
    private var cellVM = [Movie]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    // MARK: - MovieListBusinessLogic
    
    /*
     Current page of the results, when set, it makes an API Request corresponding to that page and checks of it
     less than the total pages
     */
    var currentPage : Int? {
        didSet{
            if let pages = self.totalPages{
                if currentPage! <= pages {
                    self.makeAPIRequest(at: String(currentPage!))
                }
            }
        }
    }
    
    /*
     The search text put by the user, when set, sets the default value of the current and total pages to 1 and
     remove any previous data
     */
    var searchText: String? {
        didSet {
            self.totalPages = 1
            self.currentPage = 1
            self.movies.removeAll()
        }
    }
    
    // MARK: - MovieListPresentationLogic
    
    /*
     Returns the number of rows the table view should have
     */
    var numberOfRows: Int {
        return cellVM.count
    }
    /*
     Closure to reload the tableView
     */
    var reloadTableViewClosure: (()->())?
    /*
     Returns the cellViewModel for that particular IndexPath
     */
    func getCellViewModel(at index: IndexPath) -> Movie {
        return cellVM[index.row]
    }
    
    // MARK: - API Request and Data Handling
  
    /*
     Make API Request with the search text and the current page
     */
    private func makeAPIRequest(at page: String) {
        let path = Path.API
        let parameters = ["api_key" : Path.API_KEY, "query" : searchText!, "page" : page]
        ServerRequest().getRequest(path: path, parameters: parameters, completionHandler: extractData(_:))
    }
    
    /*
     Extracts the relevant data for the Cell View Model
     */
    private func extractData(_ apiResult: Any) {
        guard let movieData = apiResult as? [String:Any] else{
            return
        }
        guard let results = movieData["results"] as? [[String:Any]] else {
            return
        }
        if !results.isEmpty {
            if self.currentPage == 1 {
                totalPages = movieData["total_pages"] as? Int
                saveData()
            }
            createCellVM(from: results)
           
        }
        else {
            // show Alert Controller
        }
    }
    
    /*
     Creates the Cell View Model
     */
    private func createCellVM(from results: [[String:Any]]){
        for result in results {
            self.movies.append(Movie(result))
        }
        self.cellVM = self.movies
    }
    
    
    
}

// MARK: - RealmDB

extension MovieListInteractor {
    /*
     Creates a Realm Object and checks for the existing data
     */
    private func saveData() {
        let realm = try! Realm()
        let newLastSearch = makeLastSearch(searchText!)
        
        if let first = realm.objects(SearchList.self).first{
            updateSearchList(realm, first.list, newLastSearch)
        }
        else{
            createNewSearchList(realm, newLastSearch)
        }
        
    }
    
    /*
     Creates a new row of data with the search Text
     */
    private func createNewSearchList(_ realm: Realm, _ newLastSearch: LastSearch){
        try! realm.write {
            let searchList = SearchList()
            searchList.list.append(newLastSearch)
            realm.add(searchList)
        }
    }
    
    /*
     Updates the existing data, adds it on the List if the count is less than 10, other wise removes the oldest data
     */
    private func updateSearchList(_ realm: Realm, _ list: List<LastSearch>, _ newLastSearch: LastSearch) {
        if list.count == 10 {
            try! realm.write {
                list.removeFirst()
                list.append(newLastSearch)
            }
        }
            
        else{
            try! realm.write {
                list.append(newLastSearch)
            }
        }
    }
    
    /*
     Creates and returns a LastSearch Object
     */
    private func makeLastSearch(_ name: String) -> LastSearch {
        let newLastSearch = LastSearch()
        newLastSearch.name = name
        
        return newLastSearch
    }
}
