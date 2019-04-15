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
    
    var aryDownloadedData:[Country]?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateRowsWithCountries(query: nil, page: 1, limit: 1)
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
