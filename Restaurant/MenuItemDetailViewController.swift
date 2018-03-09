//
//  MenuItemDetailViewController.swift
//  Restaurant
//
//  Created by Michael Berend on 07/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    var delegate: AddToOrderDelegate?
    // create outlets for lables and button
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addToOrderButton: UIButton!
    
    // create variable of type menu item
    var menuItem: MenuItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        // call function to update lables and buttons
        updateUI()
        // check if hyarchy of viewcontrollers is correct
        setUpDelegate()
    }
    
    // update labels, buttons and images
    func updateUI() {
        titleLabel.text = menuItem.name
        priceLabel.text = String(format: "$%.f", menuItem.price)
        descriptionLabel.text = menuItem.description
        addToOrderButton.layer.cornerRadius = 5.0
        MenuController.shared.fetchImage(url: menuItem.imageURL) { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }

    // enlarge order button when tappes
    @IBAction func addToOrderButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 4.0, y: 4.0)
            self.addToOrderButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        delegate?.added(menuItem: menuItem)
    }
    
    // check view controller hyarchy
    func setUpDelegate() {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController, let orderTableViewController = navController.viewControllers.first as? OrderTableViewController {
            delegate = orderTableViewController
        }
    }
    

    

}
