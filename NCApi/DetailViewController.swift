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
    @IBOutlet weak var subRegion: UILabel!
    @IBOutlet weak var currencyName: UILabel!
    
    @IBOutlet weak var region: UILabel!
    @IBOutlet weak var nativeName: UILabel!
    @IBOutlet weak var latitude: UILabel!
    @IBOutlet weak var longitude: UILabel!
    @IBOutlet weak var area: UILabel!
    @IBOutlet weak var nativeLanguage: UILabel!
    @IBOutlet weak var currencySymbol: UILabel!

    
    var countryTextInfo:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.flagImageView.imageFromServerURL(self.country?.FlagPng ?? "", placeHolder: nil)
        self.countryName.text = self.country?.Name
        self.countryName.text = self.country?.Name
        
        self.nativeName.text = self.country?.NativeName
        self.nativeLanguage.text = self.country?.Name
        self.region.text = self.country?.Region
        self.subRegion.text = self.country?.SubRegion
        self.latitude.text = self.country?.Latitude
        self.longitude.text = self.country?.Longitude
        
        if let ar = self.country?.Area {
            self.area.text = String(ar)
        }
        
        self.currencyName.text = self.country?.CurrencyName
        self.currencySymbol.text = self.country?.CurrencySymbol
        
       navigationItem.title = self.country?.Name
    }
}
