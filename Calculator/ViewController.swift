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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var isUserTypingNow = false
    var wasDotTyped = false
    let emptyDisplay = "0"
    
    var evaluator = Evaluator()
    
    @IBAction func digitPressed(sender: UIButton) {
        if !isUserTypingNow {
            displayText = sender.currentTitle!
            if displayText == "." {
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
            
            displayText += sender.currentTitle!
        }
    }
    
    func clearDisplay() {
        displayText = emptyDisplay
        isUserTypingNow = false
        wasDotTyped = false
    }
    
    @IBAction func clearButtonPressed(sender: UIButton) {
        clearDisplay()
    }
    
    var displayText: String {
        get {
            return display!.text!
        }
        
        set {
            display!.text = newValue
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(displayText)?.doubleValue
        }
        
        set {
            if let newValue = newValue {
                displayText = "\(newValue)"
            } else {
                displayText = "nil"
            }
        }
        
    }
    
    @IBAction func enterPressed(sender: UIButton) {
        if let operand = displayValue {
            evaluator.putNumber(operand)
        }
        clearDisplay()
    }
    
    @IBAction func operatorPressed(sender: UIButton) {
        if isUserTypingNow {
            if let operand = displayValue {
                evaluator.putNumber(operand)
            }
        }
        clearDisplay()
        
        evaluator.putOpearator(sender.currentTitle!)
        displayValue = evaluator.evaluate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

