//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Viktoria on 13/3/24.
//

import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String {
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate(_ number1: Double, _ number2: Double) throws -> Double {
        switch self{
        case .add:
            return number1 + number2
            
        case .substract:
            return number1 - number2
        
        case .multiply:
            return number1 * number2
            
        case .divide:
            if number2 == 0 {
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoriItem {
    case number(Double)
    case operation(Operation)
}


class ViewController: UIViewController {
    
    var labelText: String = ""

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return}
        
        if buttonText == "," && lable.text?.contains(",") == true{
            return
        }
        if lable.text!.count < 23{
            if lable.text == "0"{
                lable.text = buttonText
            }
            else{
                lable.text?.append(buttonText)
            }
        }
        
        labelText = lable.text!
        
    }
    
    @IBAction func operationbuttonPressed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
            else{return}
        
        guard
            let lableText = lable.text,
            let lableNumber = numberFormatter.number(from: lableText)?.doubleValue
            else{return}
        
        
        calculationHistory.append(.number(lableNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLableText()
    }
    
    @IBAction func clearbuttonPressed() {
        calculationHistory.removeAll()
        
        resetLableText()
    }
    
    @IBAction func calculatebuttonPressed() {
        guard
            let lableText = lable.text,
            let lableNumber = numberFormatter.number(from: lableText)?.doubleValue
            else{return}
        
        calculationHistory.append(.number(lableNumber))
        
        do {
            let result = try calculate()
            
            lable.text = numberFormatter.string(from: NSNumber(value: result))
        } catch {
            lable.text = "Ошибка"
        }
        
        calculationHistory.removeAll()
    }
    
    @IBOutlet weak var lable: UILabel!
    
    var calculationHistory: [CalculationHistoriItem] = []
    
    lazy var numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        resetLableText()
    }
    
    func calculate() throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else {return 0}
        
        var currentResult = firstNumber
        
        for index in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard
                case .operation(let operation) = calculationHistory[index],
                case .number(let number) = calculationHistory[index + 1]
                else{break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        
        return currentResult
    }
    
    func resetLableText(){
        lable.text = "0"
    }


}

