//
//  Country.swift
//  NCApi
//
//  Created by Leonardo Reis on 12/04/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import Foundation

struct Country: Codable {
    var name: String
    var alpha2Code: String
    var alpha3Code: String
    var nativeName: String
    var region: String
    var subregion: String
    var latitude: String
    var longitude: String
    var area: Int
    var numericCode: Int
    var nativeLanguage: String
    var currencyCode: String
    var currencyName: String
    var currencySymbol: String
    var flag: String
    var flagPng: String
}

//    pPage    int?    False    Pagination
//    pLimit    int?    False    Limit of objects response
func getCountries(query: String, page: Int, limit: Int) {
    let jsonUrlString = "http://countryapi.gear.host/v1/Country/getCountries?" + "pName=\(String(query))" + "pPage=\(String(page))" + "pLimit=\(String(limit))"
    
    guard let url = URL(string: jsonUrlString) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
        
        guard let data = data else { return }
        
        do {
            let countries = try JSONDecoder().decode(Country.self, from: data)
            print("sd")
            print(countries)
        } catch let jsonErr {
            print("Error", jsonErr)
        }
    }.resume()
}
