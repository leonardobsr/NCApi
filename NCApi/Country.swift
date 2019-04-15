//
//  Country.swift
//  NCApi
//
//  Created by Leonardo Reis on 12/04/19.
//  Copyright © 2019 LeonardoBSR. All rights reserved.
//

import Foundation

struct Response: Codable {
    var IsSuccess: Bool
    var UserMessage: String?
    var TechnicalMessage: String?
    var TotalCount: Int
    var Response: [Country]
    
    static func getCountries(query: String?, page: Int, limit: Int, completion: @escaping ( _ data : Response?, _ error: Error?)->()) {
        
        var jsonUrlString = "http://countryapi.gear.host/v1/Country/getCountries?" + "pPage=\(String(page))&" + "pLimit=\(String(limit))"
        
        if let query = query {
            jsonUrlString = jsonUrlString + "&pName=\(String(query))"
        }
        
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else { return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(self, from: data)
                completion(response, error)
            } catch {
                print("Error", error)
            }
            }.resume()
    }
}

struct Country: Codable {
    var Name: String?
    var Alpha2Code: String?
    var Alpha3Code: String?
    var NativeName: String?
    var Region: String?
    var SubRegion: String?
    var Latitude: String?
    var Longitude: String?
    var Area: Int?
    var NumericCode: Int?
    var NativeLanguage: String?
    var CurrencyCode: String?
    var CurrencyName: String?
    var CurrencySymbol: String?
    var Flag: String?
    var FlagPng: String?
}
