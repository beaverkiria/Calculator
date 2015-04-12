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
        case Constant(String, Double)
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
                case .Constant(let constnat, _):
                    return constnat
                }
            }
        }
    }
    
    private var knownOps = [String: Op]()
    private var knownConstant = [String: Op]()
    private var opStack = [Op]()
    
    init() {
        func learnOp(op: Op) {
            knownOps[op.description] = op
        }
        func learnConstant(op: Op) {
            knownConstant[op.description] = op
        }
        
        learnOp(Op.BynaryOperator("+", +))
        learnOp(Op.BynaryOperator("−") {$1 - $0})
        learnOp(Op.BynaryOperator("×", *))
        learnOp(Op.BynaryOperator("÷", {$1 / $0}))
        learnOp(Op.UnaryOperator("√", sqrt))
        learnOp(Op.UnaryOperator("Sin", sin))
        learnOp(Op.UnaryOperator("Cos", cos))
        
        learnConstant(Op.Constant("π", M_PI))
        learnConstant(Op.Constant("e", M_E))
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
    
    func putConstant(constantToPut: String) -> Double? {
        if let constant = knownConstant[constantToPut] {
            opStack.append(constant)
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
        case .Constant(_, let constant):
            return (constant, remainingOps)
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