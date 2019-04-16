//
//  ViewController.swift
//  NCApi
//
//  Created by Leonardo Reis on 12/04/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import UIKit


class ViewController: UITableViewController {
    
    private let tablCellId = "countryCell"
    private let detailScreenId = "countryDetailsIdentifier"
    var searchController: UISearchController!
    var aryDownloadedData:[Country]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search here..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        
        
    }
    
    func updateRowsWithCountries(query: String?, page: Int, limit: Int) {
        Response.getCountries(query: query, page: page, limit: limit, completion: { (data: Response?, error: Error?) in
            if let responseData = data {
                self.aryDownloadedData = responseData.Response
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tablCellId) as! CountryTableViewCell
        cell.countryNameLabel?.text = self.aryDownloadedData?[indexPath.row].Name

        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryDownloadedData?.count ?? 0
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
        performSegue(withIdentifier: self.detailScreenId, sender: self.aryDownloadedData?[indexPath.row])
    }
}

//MARK: - UISearchbar delegate
extension ViewController: UISearchBarDelegate{
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        tableView.reloadData()
    }
    
    
}

extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        //self.aryDownloadedData?.removeAll(keepingCapacity: false)
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            print(searchText)
            updateRowsWithCountries(query: searchText, page: 1, limit: 10)
                        
            /*
            filteredCountryArray = aryDownloadedData?.filter {$0.Name?.lowercased().contains(searchText.lowercased()) ?? false} ?? []
            
            if filteredCountryArray.count == 0{
                //Not found country than request API using search text
                updateRowsWithCountries(query: searchText, page: 1, limit: 10)
            }*/
            
            tableView.reloadData()
        }
    }
    
    
    
    
}
