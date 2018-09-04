//
//  SearchResultsInteractor.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/3/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import RealmSwift

class SearchResultsInteractor{

    let realm = try! Realm()
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
    
    var isFiltering = false
    
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
    
    func filterSearchResults(by searchText: String){
        filteredCellVM = cellVM.filter {
            $0.lowercased().contains(searchText.lowercased())
        }
    }
    
    func getLastSearches() {
        if let first = realm.objects(SearchList.self).first {
            let reversedList = first.list.reversed()
            self.cellVM = reversedList.map{
                $0.name
            }
        }
        
    }
    
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
