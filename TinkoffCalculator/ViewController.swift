//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Viktoria on 13/3/24.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return}
        print(buttonText)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

