//
//  ViewController.swift
//  Example
//
//  Created by Tacenda on 1/26/20.
//  Copyright © 2020 Tacenda. All rights reserved.
//

import UIKit
import PollfishSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func showPollfish(_ sender: Any) {
        Pollfish.show(onView: self)
    }
}

