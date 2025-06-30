//
//  CalculatorEngine.swift
//  CalcApp
//
//  Created by Muhammad Ardiansyah Asrifah on 29/06/25.
//

struct CalculatorEngine {
    enum Operator: String {
        case plus = "+"
        case minus = "−"
        case multiply = "×"
        case divide = "÷"
    }

    func calculate(lhs: Double, rhs: Double, op: Operator) -> Double {
        switch op {
        case .plus:      return lhs + rhs
        case .minus:     return lhs - rhs
        case .multiply:  return lhs * rhs
        case .divide:    return rhs == 0 ? .nan : lhs / rhs
        }
    }
}
