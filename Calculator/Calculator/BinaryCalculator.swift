//
//  BinaryCalculator.swift
//  Calculator
//
//  Created by TORI on 2021/03/30.
//

import Foundation

// enum BinaryOperator: String{
//     case add = "+"
//     case subtract = "-"
//     case and = "&"
//     case nand = "~&"
//     case or = "|"
//     case nor = "~|"
//     case xor = "^"
//     case not = "~"
//     case leftShift = "<<"
//     case rightShift = ">>"
// }

class BinaryCalculator {
    // var operators = Stack<BinaryOperator>() 
    // var operands = Stack<String>()
    var firstNumber: String = "" 
    var secondNumber: String = ""
    var tempNumber = ""
    var screenNumber = "0"
    var lastOperator = ""
    
    func binaryToInt(_ inputText: String) -> UInt8 {
        guard let intValue = UInt8(inputText, radix: 2) else {
            return 0
        }
        return intValue
    }
    
    func intToBinary(_ inputInt: UInt8) -> String {
        return String(inputInt, radix: 2)
    }
    
    func addCalculate(_ firstNumber: UInt8, _ secondNum: UInt8) -> UInt8 {
        return firstNumber + secondNum
    }
    
    func substractCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return firstNumber - secondNumber
    }
    
    func andCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return firstNumber & secondNumber
    }
    
    func orCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return firstNumber | secondNumber
    }
    
    func notCalculate(_ firstNumber: UInt8) -> UInt8 {
        return ~firstNumber
    }
    
    func xorCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return (firstNumber ^ secondNumber)
    }
    
    func nandCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return ~(firstNumber & secondNumber)
    }
    
    func norCalculate(_ firstNumber: UInt8, _ secondNumber: UInt8) -> UInt8 {
        return ~(firstNumber | secondNumber)
    }
    
    func leftShiftCalculate(_ number: UInt8) -> UInt8 {
        return number << 1 
    }
    
    func rightShiftCalculate(_ number: UInt8) -> UInt8 {
        return number >> 1 
    }
    
    func calculate(_ `operator`: String) -> UInt8 {
        print("operator", `operator`)
        switch `operator` {
        case "+":
            return addCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "-":
            return substractCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "&":
            return andCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "~&":
            return nandCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "|":
            return orCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "~|":
            return norCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "^":
            return xorCalculate(binaryToInt(firstNumber), binaryToInt(secondNumber))
        case "~":
            return notCalculate(binaryToInt(firstNumber))
        case "<<":
            return leftShiftCalculate(binaryToInt(firstNumber))
        case ">>":
            return rightShiftCalculate(binaryToInt(firstNumber))
        default:
            return 0
        }
    }
    
    func receiveInput(buttonType: String) {
        print("binary input", buttonType)
        if buttonType == "c" {
            firstNumber = ""
            secondNumber = ""
            tempNumber = ""
            return
        }
        
        if buttonType == "=" {
            secondNumber = tempNumber
            print("first", firstNumber, " second", secondNumber)
            screenNumber = intToBinary(calculate(lastOperator))
            print(screenNumber)
            return
        }
        
        if buttonType == "0" || buttonType == "1" {
            tempNumber += buttonType
            return
        }
      
        if "+-&|^~<<>>~&~|".contains(buttonType) {
            firstNumber = tempNumber
            tempNumber = ""
            lastOperator = buttonType
            return
        }
    }
}
