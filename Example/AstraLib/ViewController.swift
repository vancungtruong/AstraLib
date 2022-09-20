//
//  ViewController.swift
//  AstraLib
//
//  Created by Cung Truong on 03/16/2022.
//  Copyright (c) 2022 Cung Truong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func upgradeToPremiumTapped(_ sender: Any) {
        
        UpgradeToPremiumViewController.show(from: self)
    }
}

