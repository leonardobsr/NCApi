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
    private var searchController: UISearchController!
    private var aryDownloadedData:[Country]?
    var spinner:UIActivityIndicatorView?
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
        
    }
    
    func updateRowsWithCountries(query: String?, page: Int, limit: Int) {
        Response.getCountries(query: query, page: page, limit: limit, completion: { (data: Response?, error: Error?) in
            if let responseData = data {
                self.aryDownloadedData = responseData.Response
                DispatchQueue.main.async {
                    self.spinner?.dismissLoader()
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
        tableView.reloadData()
    }
    
    
}

//MARK: - UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text,
            !searchText.isEmpty {
            self.spinner?.startAnimating()
            updateRowsWithCountries(query: searchText, page: 1, limit: 10)
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
