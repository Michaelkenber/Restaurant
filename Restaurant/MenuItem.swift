//
//  MenuItem.swift
//  Restaurant
//
//  Created by Michael Berend on 07/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import Foundation

// define struct for menu items
struct MenuItem: Codable {
    var id: Int
    var name: String
    var description: String
    var price: Double
    var category: String
    var imageURL: URL
    
    // define keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case price
        case category
        case imageURL = "image_url"
    }
}

// define a struct that holds an array of menu items
struct MenuItems: Codable {
    let items: [MenuItem]    
}
