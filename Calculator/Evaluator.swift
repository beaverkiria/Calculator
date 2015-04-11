//
//  Evaluator.swift
//  Calculator
//
//  Created by Kirill Cherepanov on 10/04/15.
//  Copyright (c) 2015 Kirill Cherepanov. All rights reserved.
//

import Foundation

class Evaluator {
    private enum Op: Printable {
        case Operand(Double)
        case UnaryOperator(String, Double -> Double)
        case BynaryOperator(String, (Double, Double) -> Double)
        
        var description: String {
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                    
                case .UnaryOperator(let op, _):
                    return "\(op)"
                case .BynaryOperator(let op, _):
                    return "\(op)"
                }
            }
        }
    }
    
    private var knownOps = [String: Op]()
    private var opStack = [Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        
        learnOp(Op.BynaryOperator("+", +))
        learnOp(Op.BynaryOperator("−") {$1 - $0})
        learnOp(Op.BynaryOperator("×", *))
        learnOp(Op.BynaryOperator("÷", {$1 / $0}))
        learnOp(Op.UnaryOperator("√", sqrt))
    }
    
    func putNumber(operand: Double) {
        opStack.append(Op.Operand(operand))
    }
    
    func putOpearator(operatorToPut: String) {
        if let op = knownOps[operatorToPut] {
            opStack.append(op)
        }
    }
    
    private func evaluate(ops: [Op]) -> (result: Double, remainingOps: [Op])? {
        if ops.isEmpty {
            return nil
        }
        
        var remainingOps = ops
        
        switch remainingOps.removeLast() {
        case .Operand(let operand):
            return (operand, remainingOps)
            
        case .UnaryOperator(_, let op):
            if let result = evaluate(remainingOps) {
                return (op(result.result), result.remainingOps)
            }
        case .BynaryOperator(_, let op):
            if let result1 = evaluate(remainingOps) {
                if let result2 = evaluate(result1.remainingOps) {
                    return (op(result1.result, result2.result), result2.remainingOps)
                }
            }
         
        }
        return nil
    }
    
    func evaluate() -> Double? {
        if let result = evaluate(opStack) {
            return result.result
        }
        return nil
    }
}