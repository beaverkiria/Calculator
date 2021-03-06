//
//  ViewController.swift
//  Calculator
//
//  Created by Kirill Cherepanov on 10/04/15.
//  Copyright (c) 2015 Kirill Cherepanov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var display: UILabel!
    
    
    var isUserTypingNow = false
    var wasDotTyped = false
    let emptyDisplay = "0"
    
    var evaluator = Evaluator()
    
    @IBAction func digitPressed(sender: UIButton) {
        if !isUserTypingNow {
            display.text = sender.currentTitle!
            if display.text! == "." {
                wasDotTyped = true
            }
            
            isUserTypingNow = true
        } else {
            
            if sender.currentTitle! == "." {
                if wasDotTyped {
                    return
                } else {
                    wasDotTyped = true
                }
            }
            
            display.text! += sender.currentTitle!
        }
    }
    
    func clearDisplay() {
        displayValue = 0
        isUserTypingNow = false
        wasDotTyped = false
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        clearDisplay()
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue ?? nil
        }
        
        set {
            if let value = newValue {
                display.text = "\(value)"
            } else {
                display.text = "0"
            }
        }
        
    }
    
    @IBAction func constantPressed(sender: UIButton) {
        enterPressed()
        clearDisplay()
//        if let constant = sender.currentTitle {
//            displayValue = evaluator.putConstant(constant)
//        }
        display.text! = sender.currentTitle!
    }
    
    @IBAction func enterPressed() {
        if let result = evaluator.putOperand(displayValue!) {
            displayValue = result
        }
        isUserTypingNow = false
        wasDotTyped = false
        

    }
    
    @IBAction func operatorPressed(sender: UIButton) {
        enterPressed()
        if let op = sender.currentTitle {
            displayValue = evaluator.putOpearator(op)
            
        } else {
            clearDisplay()
        }
    }
    
    
}

