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
    
    init() {
        
    }
    
//    pPage    int?    False    Pagination
//    pLimit    int?    False    Limit of objects response
    static func getCountries(params: String, callback:@escaping ( _ data : [Result]?, _ error: Error?)->()) {
        let url = URL(string: "http://countryapi.gear.host/v1/Country/getCountries?" + params)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, erro) in
            if erro == nil {
                guard let encodedData = data else {
                    print("Error: No data to decode")
                    return
                }
                
                guard let countries = try? JSONDecoder().decode(response.self, from: encodedData) else {
                    print("Error: Couldn't decode data into Blog")
                    return
                }
            }else{
                callback(nil, erro)
            }
        }
        task.resume()
    }
}
