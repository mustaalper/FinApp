//
//  EarningDetailViewController.swift
//  FinApp
//
//  Created by MAA on 15.09.2022.
//

import UIKit
import CoreData

class EarningDetailViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var costTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    @IBOutlet var typeTextField: UITextField!
    
    let types = ["Diğer", "Maaş", "Yatırım", "Ek Gelir"]
    var pickerView = UIPickerView()
    
    let datePicker = UIDatePicker()
    
    var expent: Expent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        typeTextField.inputView = pickerView
        
        costTextField.keyboardType = .decimalPad
        createDatePicker()
        
        if let e = expent {
            nameTextField.text = e.earName
            costTextField.text = "\(e.earCost)"
            dateTextField.dateFormatter1(textField: dateTextField, fromDate: e.earDate!)
            typeTextField.text = e.earType
        }
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        dateTextField.dateFormatter(textField: dateTextField, fromDate: datePicker)
        self.view.endEditing(true)
    }
    
    @IBAction func saveButtonAction(_ sender: Any) {
        
        if expent == nil {
            if let name = nameTextField.text {
                let expent = Expent(context: context)
                expent.earName = name
                expent.earCost = Double(costTextField.text!) ?? 0
                expent.earDate = datePicker.date
                expent.earType = typeTextField.text
                appDelegate.saveContext()
                print("Save")
            }
        } else {
            if let e = expent, let name = nameTextField.text, let cost = Double(costTextField.text!) {
                e.earName = name
                e.earCost = cost
                e.earDate = datePicker.date
                e.earType = typeTextField.text
                appDelegate.saveContext()
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}


extension EarningDetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return types.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return types[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = types[row]
        typeTextField.resignFirstResponder()
    }
}
