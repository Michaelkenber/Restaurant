//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Michael Berend on 08/03/2018.
//  Copyright © 2018 Michael Berend. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    // create an outlet for the label
    @IBOutlet weak var timeRemainingLabel: UILabel!
    
    // create a variable for minutes remaining
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print remaining time
        timeRemainingLabel.text = "Thank you for your order! your wait time is approximately \(minutes!) minutes."


    }
    

}
