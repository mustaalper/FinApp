//
//  Extensions.swift
//  FinApp
//
//  Created by MAA on 14.09.2022.
//

import Foundation
import UIKit

extension UITextField {
    func dateFormatter(textField: UITextField, fromDate: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yy"
        
        textField.text = formatter.string(from: fromDate.date)
    }
}

extension UITextField {
    func dateFormatter1(textField: UITextField, fromDate: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yy"
        
        textField.text = formatter.string(from: fromDate)
    }
}

extension UILabel {
    func dateFormatter(label: UILabel, fromDate: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "dd.MM.yy"
        
        label.text = formatter.string(from: fromDate)
    }
}

