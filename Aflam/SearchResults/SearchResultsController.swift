//
//  SearchResultsTableViewController.swift
//  Aflam
//
//  Created by Apurva Kochar on 9/3/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit

class SearchResultsController: UITableViewController {

    /*
     resuseIdentifier for the resuable Cells
     */
    
    let reuseIdentifier = "LastSearchCell"
    
    /*
     interactor (ViewModel) which takes care of the Business and Presentation Logic
     */
    
    lazy var interactor = SearchResultsInteractor()
    
    /*
     delegate to manage the Search Controller
     */
    
    var delegate: UISearchController?
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.tableFooterView = UIView()
        initInteractor()
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // number of rows from the interactor
        return interactor.numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        
        // View Model for the cell
        
        let cellVM = interactor.getCellVM(at: indexPath)
        cell.textLabel?.text = cellVM
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // remove the suggestion from the database, to reassign its index when the API call is made
        interactor.removeSuggestion(at: indexPath)
        
        // put the suggestion on the search bar
        delegate?.searchBar.text = interactor.getCellVM(at: indexPath)
        
        // force end editing of the search bar
        delegate?.searchBar.endEditing(true)
        
        // dismiss the search results view controller
        dismiss(animated: false, completion: nil)
    }

    // MARK: - Initialization

    func initInteractor() {
        //reload the tableview when the data model changes
        
        interactor.reloadTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}
