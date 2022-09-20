//
//  DetailViewController.swift
//  FinApp
//
//  Created by MAA on 13.09.2022.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var costTextField: UITextField!
    @IBOutlet var dateTextField: UITextField!
    
    @IBOutlet var typeTextField: UITextField!
    
    let datePicker = UIDatePicker()
    
    let types = ["Yemek", "Oyun", "Fatura", "Diğer"]
    var pickerView = UIPickerView()
    
    var selectedType = ""
    
    var expent: Expent?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        pickerView.dataSource = self
        pickerView.delegate = self
        
        costTextField.keyboardType = .decimalPad
        
        createDatePicker()
        if let e = expent {
            nameTextField.text = e.name
            costTextField.text = "\(e.cost)"
            dateTextField.dateFormatter1(textField: dateTextField, fromDate: e.date!)
            typeTextField.text = e.type
        }
    }
    
    func createDatePicker() {
        // toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // bar button
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        // assign toolbar
        dateTextField.inputAccessoryView = toolbar
        // assign
        dateTextField.inputView = datePicker
        // datepicker mode
        datePicker.datePickerMode = .date
    }
    
    @objc func donePressed() {
        // formatter
        dateTextField.dateFormatter(textField: dateTextField, fromDate: datePicker)
        self.view.endEditing(true)
    }

    @IBAction func saveAction(_ sender: Any) {
        
        if expent == nil {
            if let name = nameTextField.text {
                let expent = Expent(context: context)
                expent.name = name
                expent.cost = Double(costTextField.text!) ?? 0.0
                expent.date = datePicker.date
                expent.type = typeTextField.text
                appDelegate.saveContext()
            }
        } else {
            if let e = expent, let name = nameTextField.text, let cost = Double(costTextField.text!) {
                e.name = name
                e.cost = cost
                e.date = datePicker.date
                e.type = typeTextField.text
                appDelegate.saveContext()
            }
        }
        _ = navigationController?.popViewController(animated: true)
    }
}

extension DetailViewController: UIPickerViewDelegate, UIPickerViewDataSource {
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
        self.selectedType = types[row]
        typeTextField.resignFirstResponder()
    }
}
