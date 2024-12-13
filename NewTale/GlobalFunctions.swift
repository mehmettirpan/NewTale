//
//  GlobalFunctions.swift
//  NewTale
//
//  Created by Mehmet Tırpan on 3.10.2024.
//

import UIKit

// Function to create a text field with a placeholder
func createTextField(placeholder: String) -> UITextField {
    let textField = UITextField()
    textField.placeholder = placeholder
    textField.borderStyle = .roundedRect
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
}

// Function to create a button with optional background color and corner radius
func createButton(
    title: String,
    target: Any?,
    action: Selector,
    backgroundColor: UIColor? = nil,
    cornerRadius: CGFloat? = nil,
    textColor: UIColor? = nil
) -> UIButton {
    let button = UIButton(type: .system)
    button.setTitle(title, for: .normal)
    button.addTarget(target, action: action, for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    
    // Eğer backgroundColor parametresi verilmişse, butona uygulanır
    if let backgroundColor = backgroundColor {
        button.backgroundColor = backgroundColor
    }
    
    // Eğer cornerRadius parametresi verilmişse, butonun köşeleri yuvarlanır
    if let cornerRadius = cornerRadius {
        button.layer.cornerRadius = cornerRadius
        button.layer.masksToBounds = true
    }
    
    button.setTitleColor(textColor ?? .systemBlue, for: .normal)

    return button
}


func showAlert(on viewController: UIViewController, title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default))
    viewController.present(alert, animated: true)
}

func createStackView(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill) -> UIStackView {
    let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
    stackView.axis = axis
    stackView.spacing = spacing
    stackView.alignment = alignment
    stackView.distribution = distribution
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
}

func createLabel(text: String?, font: UIFont?, textColor: UIColor = .black, numberOfLines: Int = 1) -> UILabel {
    let label = UILabel()
    label.text = text
    label.font = font
    label.textColor = textColor
    label.numberOfLines = numberOfLines
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
}
