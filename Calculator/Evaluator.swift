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
    
    func putOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    func putOpearator(operatorToPut: String) -> Double? {
        if let op = knownOps[operatorToPut] {
            opStack.append(op)
        }
        return evaluate()
    }
    
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op]) {
        if ops.isEmpty {
            return (nil, ops)
        }
        
        var remainingOps = ops
        
        switch remainingOps.removeLast() {
        case .Operand(let operand):
            return (operand, remainingOps)
            
        case .UnaryOperator(_, let op):
            let evaluationResult = evaluate(remainingOps)
            if let result = evaluationResult.result {
                return (op(result), evaluationResult.remainingOps)
            }
        case .BynaryOperator(_, let op):
            let evaluationResult1 = evaluate(remainingOps)
            if let result1 = evaluationResult1.result {
                let evaluationResult2 = evaluate(evaluationResult1.remainingOps)
                if let result2 = evaluationResult2.result {
                    return (op(result1, result2), evaluationResult2.remainingOps)
                }
            }
        }
        return (nil, ops)
    }
    
    func evaluate() -> Double? {
        let result = evaluate(opStack)
        if let evaluationResult = result.result {
            return evaluationResult
        }
        return nil
    }
}