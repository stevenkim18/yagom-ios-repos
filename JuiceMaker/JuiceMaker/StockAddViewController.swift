//
//  StockAddViewController.swift
//  JuiceMaker
//
//  Created by Sunny on 2021/03/18.
//

import UIKit

class StockAddViewController: UIViewController {
    var juiceMachine: JuiceMaker?
//    var test: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        print(juiceMachine!.checkStock(of: .strawberry))
//        print(test)
    }
    
    @IBAction func touchUpCloseButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

