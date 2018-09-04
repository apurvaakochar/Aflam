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
    var cellVM = [String]() {
        didSet{
            self.reloadTableViewClosure?()
        }
    }
    
    var numberOfRows: Int {
        return cellVM.count
    }
    
    func getCellVM(at index: IndexPath) -> String {
        return cellVM[index.row]
    }
    
    var reloadTableViewClosure: (()->())?
    
    func getLastSearches() {
        let realm = try! Realm()
        let lastSearches = realm.objects(LastSearch.self)
        self.cellVM = lastSearches.map{
            $0.name
        }
    }
}
