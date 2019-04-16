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
    
    var isFetchInProgress: Bool = false
    var totalCount: Int = 0
    var page: Int = 1
    var aryDownloadedData:[Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.prefetchDataSource = self
        updateRowsWithCountries(query: nil, page: self.page, limit: 10)
    }
    
    func onFetchCompleted(with newIndexPathsToReload: [IndexPath]?) {
        // 1
        guard let newIndexPathsToReload = newIndexPathsToReload else {
//            self.indicatorView.stopAnimating()
            tableView.isHidden = false
            tableView.reloadData()
            return
        }
        // 2
        let indexPathsToReload = visibleIndexPathsToReload(intersecting: newIndexPathsToReload)
        tableView.reloadRows(at: indexPathsToReload, with: .automatic)
    }
    
    func updateRowsWithCountries(query: String?, page: Int, limit: Int) {
        guard !self.isFetchInProgress else {
            return
        }
        self.isFetchInProgress = true
        
        Response.getCountries(query: query, page: page, limit: limit, completion: { (data: Response?, error: Error?) in
            if let responseData = data {
                DispatchQueue.main.async {
                    self.totalCount = responseData.TotalCount
                    if (self.page < self.totalCount) {
                        self.page += 1
                    }
                    self.aryDownloadedData += responseData.Response
                    self.isFetchInProgress = false
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func calculateIndexPathsToReload(from newCountries: [Country]) -> [IndexPath] {
        let startIndex = self.aryDownloadedData.count - newCountries.count
        let endIndex = startIndex + newCountries.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.totalCount
    }
    
    func visibleIndexPathsToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows ?? []
        let indexPathsIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        return Array(indexPathsIntersection)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tablCellId) as! CountryTableViewCell
        cell.countryImageView?.imageFromServerURL(self.aryDownloadedData[indexPath.row].FlagPng ?? "", placeHolder: UIImage(named: "600X400"))
        cell.countryNameLabel?.text = self.aryDownloadedData[indexPath.row].Name
        if isLoadingCell(for: indexPath) {
//            cell.configure(with: .none)
        } else {
//            cell.configure(with: self.aryDownloadedData(at: indexPath.row))
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryDownloadedData.count
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

extension ViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            self.updateRowsWithCountries(query: nil, page: page, limit: 10)
        }
    }
}
