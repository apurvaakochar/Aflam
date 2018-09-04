//
//  SearchResultsInteractor.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/3/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import RealmSwift

protocol SearchResultsBusinessLogic {
    func removeSuggestion(at indexPath: IndexPath)
}

protocol SearchResultsFilteringLogic {
    
}

protocol SearchResultsPresentationLogic {
    var numberOfRows: Int {get}
    var reloadTableViewClosure: (()->())? {get set}
    func getCellVM(at index: IndexPath) -> String
}

class SearchResultsInteractor: SearchResultsPresentationLogic{

    private let realm = try! Realm()
    
    private var cellVM = [String]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    private var filteredCellVM = [String]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    // MARK: - SearchResultsPresentationLogic

    var numberOfRows: Int {
        if isFiltering {
            return filteredCellVM.count
        }
        else{
            return cellVM.count
        }
    }
    
    func getCellVM(at index: IndexPath) -> String {
        if isFiltering {
            return filteredCellVM[index.row]
        }
        else{
            return cellVM[index.row]
        }
    }
    
    var reloadTableViewClosure: (()->())?
    
    // MARK: - SearchResultsFilteringLogic
    
    var isFiltering = false
    
    /*
     Filters the suggestions as the user types on the search bar
     */
    
    func filterSearchResults(by searchText: String){
        filteredCellVM = cellVM.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
    }
    
    /*
     Retreive the last searches from the database
     */
    
    func getLastSearches() {
        if let first = realm.objects(SearchList.self).first {
            let reversedList = first.list.reversed()
            self.cellVM = reversedList.map{
                $0.name
            }
        }
        
    }
    
    // MARK: - SearchResultsBusinessLogic
    
    /*
     removes the chosen suggetsion from the database
     */
    
    func removeSuggestion(at indexPath: IndexPath) {
        let index = (indexPath.row)
        if let first = realm.objects(SearchList.self).first {
            let list = first.list
            try! realm.write {
                list.remove(at: list.count - index - 1)
            }
        }
    }
}
