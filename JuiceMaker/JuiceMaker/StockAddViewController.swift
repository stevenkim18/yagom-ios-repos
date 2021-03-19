//
//  StockAddViewController.swift
//  JuiceMaker
//
//  Created by Sunny on 2021/03/18.
//

import UIKit

class StockAddViewController: UIViewController {
    var juiceMachine: JuiceMaker?
    
    @IBOutlet weak var stockOfStrawberry: UILabel!
    @IBOutlet weak var stockOfBanana: UILabel!
    @IBOutlet weak var stockOfPineapple: UILabel!
    @IBOutlet weak var stockOfKiwi: UILabel!
    @IBOutlet weak var stockOfMango: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        stockOfStrawberry.text = String(juiceMachine!.checkStock(of: Fruit.strawberry))
        stockOfBanana.text = String(juiceMachine!.checkStock(of: Fruit.banana))
        stockOfPineapple.text = String(juiceMachine!.checkStock(of: Fruit.pineapple))
        stockOfKiwi.text = String(juiceMachine!.checkStock(of: Fruit.kiwi))
        stockOfMango.text = String(juiceMachine!.checkStock(of: Fruit.mango))
    }
    
    @IBAction func touchUpCloseButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

