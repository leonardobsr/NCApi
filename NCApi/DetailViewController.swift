//
//  DetailViewController.swift
//  NCApi
//
//  Created by Anderson Lentz on 12/04/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var country: Country?
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.countryName.text = self.country?.Name
        self.flagImageView.imageFromServerURL(self.country?.FlagPng ?? "", placeHolder: nil)
    }
}
