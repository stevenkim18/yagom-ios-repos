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
    
    @IBOutlet weak var strawberryStockStepper: UIStepper!
    @IBOutlet weak var bananaStockStepper: UIStepper!
    @IBOutlet weak var pineappleStockStepper: UIStepper!
    @IBOutlet weak var kiwiStockStepper: UIStepper!
    @IBOutlet weak var mangoStockStepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeFriutLabel()
        initializeStepperValue()
    }
    
    @IBAction func touchUpCloseButton(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func strawberryStepperValueChanged(_ sender: Any) {
        stockOfStrawberry.text = String(Int(strawberryStockStepper.value))
        if juiceMachine!.checkStock(of: .strawberry) < Int(strawberryStockStepper.value) {
            juiceMachine!.addStock(fruit: .strawberry)
        } else {
            juiceMachine!.consumeFruit(fruit: .strawberry, stock: 1)
        }
    }
     
    @IBAction func bananaStepperValueChanged(_ sender: Any) {
        stockOfBanana.text = String(Int(bananaStockStepper.value))
        if juiceMachine!.checkStock(of: .banana) < Int(bananaStockStepper.value) {
            juiceMachine!.addStock(fruit: .banana)
        } else {
            juiceMachine!.consumeFruit(fruit: .banana, stock: 1)
        }
    }
    
    @IBAction func pineappleStepperValueChanged(_ sender: Any) {
        stockOfPineapple.text = String(Int(pineappleStockStepper.value))
        if juiceMachine!.checkStock(of: .pineapple) < Int(pineappleStockStepper.value) {
            juiceMachine!.addStock(fruit: .pineapple)
        } else {
            juiceMachine!.consumeFruit(fruit: .pineapple, stock: 1)
        }
    }
    
    @IBAction func kiwiStepperValueChanged(_ sender: Any) {
        stockOfKiwi.text = String(Int(kiwiStockStepper.value))
        if juiceMachine!.checkStock(of: .kiwi) < Int(kiwiStockStepper.value) {
            juiceMachine!.addStock(fruit: .kiwi)
        } else {
            juiceMachine!.consumeFruit(fruit: .kiwi, stock: 1)
        }
    }
    
    @IBAction func mangoStepperValueChanged(_ sender: Any) {
        stockOfMango.text = String(Int(mangoStockStepper.value))
        if juiceMachine!.checkStock(of: .mango) < Int(mangoStockStepper.value) {
            juiceMachine!.addStock(fruit: .mango)
        } else {
            juiceMachine!.consumeFruit(fruit: .mango, stock: 1)
        }
    }
    
    func initializeFriutLabel() {
        stockOfStrawberry.text = String(juiceMachine!.checkStock(of: Fruit.strawberry))
        stockOfBanana.text = String(juiceMachine!.checkStock(of: Fruit.banana))
        stockOfPineapple.text = String(juiceMachine!.checkStock(of: Fruit.pineapple))
        stockOfKiwi.text = String(juiceMachine!.checkStock(of: Fruit.kiwi))
        stockOfMango.text = String(juiceMachine!.checkStock(of: Fruit.mango))
    }
    
    func initializeStepperValue() {
        strawberryStockStepper.value = Double(juiceMachine!.checkStock(of: Fruit.strawberry))
        bananaStockStepper.value = Double(juiceMachine!.checkStock(of: .banana))
        pineappleStockStepper.value = Double(juiceMachine!.checkStock(of: .pineapple))
        kiwiStockStepper.value = Double(juiceMachine!.checkStock(of: .kiwi))
        mangoStockStepper.value = Double(juiceMachine!.checkStock(of: .mango))
    }
}

