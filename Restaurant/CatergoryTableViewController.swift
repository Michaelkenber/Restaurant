//
//  CatergoryTableViewController.swift
//  Restaurant
//
//  Created by Michael Berend on 07/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class CatergoryTableViewController: UITableViewController {
    
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // fetch and update categories
        MenuController.shared.fetchCategories { (categories) in
            if let categories = categories {
                self.updateUI(with: categories)
            }
        }
        
    }
    
    
    /// update categories
    func updateUI(with categories: [String]) {
        // go to main thread
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }
    
    /// set number of rows equal to number of categories
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    ///  dequeue cells and call function to set label text
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    /// set label text for each category and capatalize first letter
    func configure(cell: UITableViewCell, forItemAt indexpath: IndexPath) {
        let categoryString = categories[indexpath.row]
        cell.textLabel?.text = categoryString.capitalized
    }
    
    /// prepare to go to Menu view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as! MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
        }
    }
}
