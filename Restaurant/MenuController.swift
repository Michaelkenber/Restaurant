//
//  MenuController.swift
//  Restaurant
//
//  Created by Michael Berend on 07/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class MenuController {
    
    // define variable to share menu controller across views
    static let shared = MenuController()
    
    // create variable that holds an URL to retrieve the data frmom
    let baseURL = URL(string: "https://resto.mprog.nl/")!

    /// function for fetching the categories from the baseURL
    func fetchCategories(completion: @escaping ([String]?) -> Void) {
    // add path to URL
    let categoryURL = baseURL.appendingPathComponent("categories")
        // retrieve data from URL, if possible
        let task = URLSession.shared.dataTask(with: categoryURL) { (data, response, error) in
            if let data = data,
            let jsonDictionary = try? JSONSerialization.jsonObject(with: data) as? [String : Any],
                let categories = jsonDictionary?["categories"] as? [String] { completion(categories)
            } else {
                completion(nil)
            }
        }
        // send the method
        task.resume()
    }

    /// function for fetching menu item from baseURL
    func fetchMenuItems(categoryName: String, completion: @escaping ([MenuItem]?) -> Void) {
        // add correct path to base url
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL, resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category", value: categoryName)]
        let menuURL = components.url!
        let task = URLSession.shared.dataTask(with: menuURL) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
                let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data) {
                completion(menuItems.items)
            } else {
                completion(nil)
            }
        }
        // send the method
        task.resume()
    }

    /// function to submit order
    func submitOrder(menuIds: [Int], completion: @escaping (Int?) -> Void) {
        // add correct path to URL
        let orderURL = baseURL.appendingPathComponent("order")
        var request = URLRequest(url: orderURL)
        // change method to post
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        // encode data
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let preparationTime = try? jsonDecoder.decode(PreparationTime.self, from: data) {
                completion(preparationTime.prepTime)
            } else {
                completion(nil)
            }
            
        }
        // send the method
        task.resume()
    }
    
    // function for fetching the image from baseURL
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        // if ther eis an image retrieve it, else complete with "image not found" picture
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data,
                let image = UIImage(data: data) {
                completion(image)
            } else {
                completion(#imageLiteral(resourceName: "notFound3"))
            }
        }
        // send the method
        task.resume()
    }
    
    
    
}
