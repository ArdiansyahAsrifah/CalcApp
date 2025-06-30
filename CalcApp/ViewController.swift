//
//  ViewController 2.swift
//  CalcApp
//
//  Created by Muhammad Ardiansyah Asrifah on 29/06/25.
//

import UIKit
import Combine

class ViewController: UIViewController {

    private let viewModel = CalculatorViewModel()
    private var cancellables: Set<AnyCancellable> = []

    // UI elemen
    private let displayLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.font = .systemFont(ofSize: 48, weight: .thin)
        label.textAlignment = .right
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        label.backgroundColor = UIColor(white: 0.1, alpha: 1)
        label.textColor = .systemGreen
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 12
        return label
    }()

    private lazy var buttonTitles: [[String]] = [
        ["C", "÷", "×", "−"],
        ["7", "8", "9", "+"],
        ["4", "5", "6", "="],
        ["1", "2", "3", "0"]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        layoutUI()
        bindViewModel()
    }

    private func layoutUI() {
        // label
        view.addSubview(displayLabel)
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            displayLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            displayLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            displayLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            displayLabel.heightAnchor.constraint(equalToConstant: 90)
        ])

        // grid tombol
        let mainStack = UIStackView()
        mainStack.axis = .vertical
        mainStack.spacing = 12
        mainStack.distribution = .fillEqually
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: displayLabel.bottomAnchor, constant: 20),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])

        // create rows
        for row in buttonTitles {
            let rowStack = UIStackView()
            rowStack.axis = .horizontal
            rowStack.spacing = 12
            rowStack.distribution = .fillEqually
            for title in row {
                let button = makeButton(title: title)
                rowStack.addArrangedSubview(button)
            }
            mainStack.addArrangedSubview(rowStack)
        }
    }

    private func makeButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28, weight: .medium)
        button.backgroundColor = title.isNumber ? UIColor(white: 0.2, alpha: 1) : UIColor(white: 0.3, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        return button
    }

    // MARK: - Actions
    @objc private func buttonPressed(_ sender: UIButton) {
        guard let title = sender.currentTitle else { return }

        let feedback = UIImpactFeedbackGenerator(style: .soft)
        feedback.impactOccurred()

        if title == "C" {
            viewModel.clear()
        } else if title == "=" {
            viewModel.inputEquals()
        } else if ["+", "−", "×", "÷"].contains(title) {
            viewModel.inputOperator(title)
        } else if let digit = Int(title) {
            viewModel.inputDigit(digit)
        }
    }

    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.$displayText
            .receive(on: RunLoop.main)
            .sink { [weak self] text in
                self?.displayLabel.text = text
            }
            .store(in: &cancellables)
    }
}

private extension String {
    var isNumber: Bool { Int(self) != nil }
}
