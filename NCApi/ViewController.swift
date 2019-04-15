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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tablCellId) as! CountryTableViewCell
        cell.countryNameLabel?.text = "Country"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: detailScreenId, sender: nil)

    }
}
