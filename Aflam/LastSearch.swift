//
//  LastSearch.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/3/18.
//  Copyright © 2018 careem. All rights reserved.
//

import Foundation
import RealmSwift

class LastSearch: Object {
    @objc dynamic var name = ""
}

class SearchList: Object {
    let list = List<LastSearch>()
}
