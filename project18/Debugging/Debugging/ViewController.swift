//
//  ViewController.swift
//  Debugging
//
//  Created by Arvin Shen on 1/3/22.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        for i in 1...100 {
            print("Got number \(i).")
        }
    }
}
