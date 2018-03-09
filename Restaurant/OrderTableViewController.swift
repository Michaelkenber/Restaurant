//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Michael Berend on 07/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

protocol AddToOrderDelegate {
    func added(menuItem: MenuItem)
}

class OrderTableViewController: UITableViewController, AddToOrderDelegate {
    
    // define array to hold menu items and variable to hold minutes for an order
    var menuItems = [MenuItem]()
    var orderMinutes: Int?
    
    /// add chosen item to array of menuitems and in update the badge
    func added(menuItem: MenuItem) {
        menuItems.append(menuItem)
        let count = menuItems.count
        let indexPath = IndexPath(row: count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        updateBadgeNumber()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set an edit button on the top left
        navigationItem.leftBarButtonItem = editButtonItem
    }

    /// set number of rows equal to menu items
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    /// dequeue cells and call function to update labels
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)
        configure(cell: cell, forItemAt: indexPath)
        return cell
    }
    
    /// update labels with apropiate price and text
    func configure(cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
    }
    
    /// if there are menu items ordered show appropriate badge value
    func updateBadgeNumber() {
        let badgeValue = menuItems.count > 0 ? "\(menuItems.count)" : nil
        navigationController?.tabBarItem.badgeValue = badgeValue
    }
    
    /// allow for editing
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    /// define how to delete items and update badgeNumber afterwards
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            menuItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            updateBadgeNumber()
        }
    }
    
    /// remove all items and update badge number when unwinded to order list
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        menuItems.removeAll()
        tableView.reloadData()
        updateBadgeNumber()
    }
    
    /// how to react when submit button is text
    @IBAction func submitTapped(_ sender: Any) {
        // calculate total, when submit button is tapped
        let orderTotal = menuItems.reduce(0.0) { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        
        // convert order total to string
        let formattedOrder = String(format: "$%.2f", orderTotal)
        
        // show alert if user is sure of submitting order and upload
        let alert = UIAlertController(title: "Confim Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            self.uploadOrder()
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    /// updload order and go to confirmation screen
    func uploadOrder() {
        let menuIds = menuItems.map{ $0.id }
        MenuController.shared.submitOrder(menuIds: menuIds) { (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    /// prepare to go to next confirmation screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
    
        }
    }


}
