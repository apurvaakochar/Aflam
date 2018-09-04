//
//  SearchResultsTableViewController.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/3/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController {

    let reuseIdentifier = "LastSearchCell"
    lazy var interactor = SearchResultsInteractor()
    var selectedText: String?
    var delegate: UISearchController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        initInteractor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let cellVM = interactor.getCellVM(at: indexPath)
        cell.textLabel?.text = cellVM
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        interactor.removeSuggestion(at: indexPath)
        delegate?.searchBar.text = interactor.getCellVM(at: indexPath)
        delegate?.searchBar.endEditing(true)
        dismiss(animated: false, completion: nil)
    }

    func initInteractor() {
        interactor.reloadTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}
