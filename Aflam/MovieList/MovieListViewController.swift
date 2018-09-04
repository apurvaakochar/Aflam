//
//  MovieListViewController.swift
//  Aflam
//
//  Created by Apurva Kochar on 8/31/18.
//  Copyright © 2018 careem. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListViewController: UITableViewController, UISearchControllerDelegate {

    let reuseIdentifier = "MovieDetails"
    let searchController = UISearchController(searchResultsController: SearchResultsController())
    lazy var interactor = MovieListInteractor()
    
    @IBOutlet weak var searchText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        initSearchController()
        initInteractor()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
  
    @IBAction func searchButtonPressed(_ sender: Any) {
        interactor.searchText = self.searchText.text
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Enter the name of the movie"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        self.searchController.searchResultsController?.view.addObserver(self, forKeyPath: "hidden", options: [], context: nil)
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let someView: UIView = object as! UIView? {
            
            if (someView == self.searchController.searchResultsController?.view &&
                (keyPath == "hidden") &&
                (searchController.searchResultsController?.view.isHidden)! &&
                searchController.searchBar.isFirstResponder) {
                
                searchController.searchResultsController?.view.isHidden = false
            }
            
        }
    }
    
    
    func willPresentSearchController(_ searchController: UISearchController) {
        if let searchResultsController = searchController.searchResultsController as? SearchResultsController {
            searchResultsController.view.isHidden = false
            searchResultsController.delegate = searchController
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if (searchText.isEmpty) {
            searchController.searchResultsController?.view.isHidden = false
        }
    }
    
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchController.searchResultsController?.view.isHidden = true
        let searchText = searchBar.text
        print(searchText)
        if !(searchText?.isEmpty)! {
            interactor.searchText = searchText
        }
    }

    
    func initInteractor() {
        interactor.reloadTableViewClosure = {[weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return interactor.numberOfRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MovieDetailsCell
        let cellVM = interactor.getCellViewModel(at: indexPath)
        cell.date.text = cellVM.date
        cell.name.text = cellVM.name
        cell.overview.text = cellVM.overview
        cell.poster.kf.setImage(with: cellVM.posterUrl)
        if indexPath.row == interactor.numberOfRows - 1 {
            interactor.currentPage = interactor.currentPage! + 1
        }
        return cell
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension MovieListViewController: UISearchBarDelegate {
    
}

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    
    
}
