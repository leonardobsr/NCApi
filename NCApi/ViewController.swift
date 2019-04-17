//
//  ViewController.swift
//  NCApi
//
//  Created by Leonardo Reis on 12/04/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    let tablCellId = "countryCell"
    let detailScreenId = "countryDetailsIdentifier"
    var searchController: UISearchController!
    var spinner:UIActivityIndicatorView?
    
    var isFetchInProgress: Bool = false
    var query: String? = nil
    var totalCount: Int = 0
    var page: Int = 1
    var aryDownloadedData:[Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Country name"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        spinner = makeSpinner(view: self.view)
        
        tableView.prefetchDataSource = self
        updateRowsWithCountries(query: query, page: page, limit: 10)
    }
    
    func updateRowsWithCountries(query: String?, page: Int, limit: Int) {
        guard !isFetchInProgress else {
            return
        }
        
        isFetchInProgress = true
        
        Response.getCountries(query: query, page: page, limit: limit, completion: { (data: Response?, error: Error?) in
            if let responseData = data {
                DispatchQueue.main.async {
                    self.page += 1
                    self.isFetchInProgress = false
                    self.totalCount = responseData.TotalCount
                    self.aryDownloadedData += responseData.Response
                    self.spinner?.dismissLoader()
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryDownloadedData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tablCellId) as! CountryTableViewCell
        
        cell.countryImageView?.imageFromServerURL(aryDownloadedData[indexPath.row].FlagPng ?? "", placeHolder: UIImage(named: "600X400"))
        cell.countryNameLabel?.text = aryDownloadedData[indexPath.row].Name
        
        return cell
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == aryDownloadedData.count - 1 {
            updateRowsWithCountries(query: query, page: page, limit: 10)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case self.detailScreenId:
            let destVC : DetailViewController = segue.destination as! DetailViewController
            destVC.country = sender as? Country
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: self.detailScreenId, sender: self.aryDownloadedData[indexPath.row])
    }
}

//MARK: - UITableView Prefetching
extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        updateRowsWithCountries(query: query, page: page, limit: 10)
    }
    
    func makeSpinner(view: UIView) -> UIActivityIndicatorView {
        
        let spinner = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 70, height:70))
        spinner.backgroundColor = UIColor.black
        spinner.layer.cornerRadius = 3.0
        spinner.clipsToBounds = true
        spinner.hidesWhenStopped = true
        spinner.style = UIActivityIndicatorView.Style.white;
        spinner.center = view.center
        view.addSubview(spinner)
        return spinner
    }
}

//MARK: - UISearchbar delegate
extension ViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        query = nil
        page = 1
        updateRowsWithCountries(query: query, page: page, limit: 10)
        spinner?.startAnimating()
    }
    
    
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
                query = searchText
                self.spinner?.startAnimating()
                updateRowsWithCountries(query: query, page: page, limit: 10)
                tableView.reloadData()
            }
    }
}

//MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView {
    func dismissLoader() {
        self.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
