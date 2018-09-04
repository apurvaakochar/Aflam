//
//  MovieListViewController.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit
import Kingfisher


class MovieListViewController: UITableViewController{

    /*
     resuseIdentifier for the resuable Cells
     */
    let reuseIdentifier = "MovieDetails"
    /*
     search controller where the user types a query and the results are displayed in SearchResultsController
     */
    let searchController = UISearchController(searchResultsController: SearchResultsController())
    /*
    interactor (ViewModel) which takes care of the Business and Presentation Logic
    */
    lazy var interactor: (MovieListPresentationLogic & MovieListBusinessLogic) = MovieListInteractor()
    
    
    // MARK: - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // removal of the extra separation lines
        
        tableView.tableFooterView = UIView()
        
        // initialize UISearchController
        initSearchController()
        
        // initialize the interactor to extablish strong binding between the view controller and the interactor
        initInteractor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // to show the search controller on the first instead of scrolling up
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = false
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.hidesSearchBarWhenScrolling = true
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
    // MARK: - Initialization
    
    private func initSearchController() {
        // delegate to know when the searchResultsController is presented
        searchController.delegate = self
        
        // delegate to obseve the changes in the searchBar
        searchController.searchBar.delegate = self
        
        // UISearchResultsUpdating protocol to observe the changes when the searchBar is updated
        searchController.searchResultsUpdater = self
        if #available(iOS 9.1, *) {
            searchController.obscuresBackgroundDuringPresentation = false
        } else {
            searchController.dimsBackgroundDuringPresentation = false
        }
        searchController.searchBar.placeholder = "Enter the name of the movie"
        
        // KVO to observer changes and show the searchResultsController when the searchBar starts editing
        searchController.searchResultsController?.view.addObserver(self, forKeyPath: "hidden", options: [], context: nil)
        
        // Embedding the searchController on the navigation item for iOS 11.0 and above
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        }
        // Embedding the searchController on the table view header for iOS 11.0 and above
        else {
            tableView.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
    }
    
    private func initInteractor() {
        // defining and closure and hence estalishing binding between the view controller and the interactor
        interactor.reloadTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
   
    // MARK: - Observe Value
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        // show the SearchResultsController on clicking on the searchController
        if let someView: UIView = object as! UIView? {
            
            if someView == searchController.searchResultsController?.view &&
                keyPath == "hidden" && (searchController.searchResultsController?.view.isHidden)! &&
                searchController.searchBar.isFirstResponder {
                    searchController.searchResultsController?.view.isHidden = false
            }
            
        }
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
        // MovieDetailsCell is the custom UITableViewCell for the design
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieDetailsCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        // View Model for the cell
        let cellVM = interactor.getCellViewModel(at: indexPath)
        cell.date.text = cellVM.date
        cell.name.text = cellVM.name
        
        // Kingfisher library taking care of the image retreival from the url and takes care of the caching and displaying it on the image view
        cell.poster.kf.setImage(with: cellVM.posterUrl)
        
        // to check if the user has scrolled down to the bottom of the list
        if indexPath.row == interactor.numberOfRows - 1 {
            loadNextPage()
        }
        
        return cell
    }

    // MARK: - Load Next Page
    
    private func loadNextPage() {
        interactor.currentPage = interactor.currentPage! + 1
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! MovieDetailsViewController
        let selectedCell = sender as! MovieDetailsCell
        let selectedIndex = tableView.indexPath(for: selectedCell)
        destinationViewController.imageUrl = interactor.getCellViewModel(at: selectedIndex!).posterUrl
        destinationViewController.overviewText = interactor.getCellViewModel(at: selectedIndex!).overview
    }

}

// MARK: - UISearchBarDelegate

extension MovieListViewController: UISearchBarDelegate {
    /*
     show the searchResultsController even when the searchBar is empty
     */
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.isEmpty) {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    /*
     tell the interactor that there is something to such for! hurray!
     */
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchResultsController?.view.isHidden = true
        let searchText = searchBar.text
        if !(searchText?.isEmpty)! {
            interactor.searchText = searchText
        }
    }
}

// MARK: - UISearchResultsUpdating

extension MovieListViewController: UISearchResultsUpdating {
    /*
     filter the SUGGESTIONS on the searchResultsController to make sure that Suggetions are persisted
     */
    func updateSearchResults(for searchController: UISearchController) {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsController {
            searchResultsController.interactor.isFiltering = isFiltering()
            searchResultsController.interactor.filterSearchResults(by: searchController.searchBar.text!)
        }
    }
    
    /*
     check if the suggestions are getting filtered
     */
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    /*
     check if the searchBar is empty
     */
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
}

// MARK: - UISearchControllerDelegate

extension MovieListViewController: UISearchControllerDelegate {
    /*
     assign delegate to the SearchResultsViewController so that it ends the SearchController editing when a SUGGESTION is selected
     */
    
    func willPresentSearchController(_ searchController: UISearchController) {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsController {
            searchResultsController.view.isHidden = false
            searchResultsController.delegate = searchController
        }
    }
}
