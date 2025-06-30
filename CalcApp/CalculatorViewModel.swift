//
//  CalculatorViewModel.swift
//  CalcApp
//
//  Created by Muhammad Ardiansyah Asrifah on 29/06/25.
//

import Foundation

final class CalculatorViewModel {
    private let engine = CalculatorEngine()

    // State
    @Published private(set) var displayText = "0"

    private var currentNumber: Double = 0
    private var previousNumber: Double = 0
    private var pendingOperator: CalculatorEngine.Operator?
    private var isEnteringNumber = false

    // Input: digit (0‑9)
    func inputDigit(_ digit: Int) {
        if isEnteringNumber {
            if displayText == "0" {
                displayText = "\(digit)"
            } else {
                displayText += "\(digit)"
            }
        } else {
            displayText = "\(digit)"
            isEnteringNumber = true
        }
        currentNumber = Double(displayText) ?? 0
    }

    // Input: operator (+,−,×,÷)
    func inputOperator(_ symbol: String) {
        guard let op = CalculatorEngine.Operator(rawValue: symbol) else { return }
        previousNumber = currentNumber
        pendingOperator = op
        isEnteringNumber = false
    }

    // Input: =
    func inputEquals() {
        guard let op = pendingOperator else { return }
        let result = engine.calculate(lhs: previousNumber, rhs: currentNumber, op: op)
        displayText = result.isNaN ? "Error" : String(result)
        currentNumber = result
        isEnteringNumber = false
        pendingOperator = nil
    }

    // Input: Clear
    func clear() {
        displayText = "0"
        currentNumber = 0
        previousNumber = 0
        pendingOperator = nil
        isEnteringNumber = false
    }
}
