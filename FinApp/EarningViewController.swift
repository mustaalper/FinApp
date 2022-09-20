//
//  EarningViewController.swift
//  FinApp
//
//  Created by MAA on 14.09.2022.
//

import UIKit
import CoreData

class EarningViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalLabel: UILabel!
    @IBOutlet var startDateTextField: UITextField!
    @IBOutlet var endDateTextField: UITextField!
    @IBOutlet var segmentedController: UISegmentedControl!
    @IBOutlet var addBarButton: UIBarButtonItem!
    
    var expentList = [Expent]()
    
    var selectedType = false
    var selectIndex = 0
    
    let datePicker = UIDatePicker()
    let datePicker1 = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        createDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFilterEarning(filter: "")
        tableView.reloadData()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = datePicker
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = datePicker1
        datePicker.datePickerMode = .date
        datePicker1.datePickerMode = .date
    }
    
    @objc func donePressed() {
        startDateTextField.dateFormatter(textField: startDateTextField, fromDate: datePicker)
        endDateTextField.dateFormatter(textField: endDateTextField, fromDate: datePicker1)
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        if segue.identifier == "toEarningDetail" {
            let destVC = segue.destination as! EarningDetailViewController
            destVC.expent = expentList[index!]
        }
    }
    
    func getFilterEarning(filter: String) {
        do {
            if filter == "" {
                let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                let pred = NSPredicate(format: "name == nil")
                request.predicate = pred
                let sort = NSSortDescriptor(key: #keyPath(Expent.earDate), ascending: false)
                request.sortDescriptors = [sort]
                expentList = try context.fetch(request)
                totalEarning(type: "")
                self.addBarButton.isEnabled = true
                self.selectedType = false
            } else {
                let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                let pred = NSPredicate(format: "name == nil && earType CONTAINS '\(filter)'")
                request.predicate = pred
                let sort = NSSortDescriptor(key: #keyPath(Expent.earDate), ascending: false)
                request.sortDescriptors = [sort]
                expentList = try context.fetch(request)
                totalEarning(type: filter)
                self.addBarButton.isEnabled = false
                self.selectedType = true
            }
        } catch {
            print(error)
        }
    }
    
    func totalEarning(type: String) {
        var total: Double = 0.0
        if expentList.count != 0 {
            for i in 0...expentList.count - 1 {
                total += expentList[i].earCost
            }
            if type == "" {
                totalLabel.text = "Toplam Gelir : \(String(format: "%.2f", total)) ₺"
            } else {
                totalLabel.text = "Toplam \(type) : \(String(format: "%.2f", total)) ₺"
            }
        } else {
            totalLabel.text = "Toplam \(type) : - ₺"
        }
    }
    
    @IBAction func typeDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getFilterEarning(filter: "")
            selectIndex = 0
        case 1:
            getFilterEarning(filter: "Maaş")
            selectIndex = 1
        case 2:
            getFilterEarning(filter: "Yatırım")
            selectIndex = 2
        case 3:
            getFilterEarning(filter: "Ek Gelir")
            selectIndex = 3
        case 4:
            getFilterEarning(filter: "Diğer")
            selectIndex = 4
        default:
            break
        }
        tableView.reloadData()
    }
    

    @IBAction func filtreButtonAction(_ sender: Any) {
        if startDateTextField.text?.isEmpty == true || endDateTextField.text?.isEmpty == true {
            print("Hata")
        } else {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            //let dateFrom = calendar.startOfDay(for: Date())
            let dateFrom = calendar.startOfDay(for: datePicker.date)
            //let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)
            let dateTo = calendar.startOfDay(for: datePicker1.date)
            let delta = dateFrom.distance(to: dateTo)
            let x = (delta / 86400) + 1
            //print(x)
            let dateTo1 = calendar.date(byAdding: .day, value: Int(x), to: dateFrom)
            if selectedType == true {
                do {
                    var filter = ""
                    switch selectIndex {
                    case 0:
                        print("0")
                        filter = ""
                    case 1:
                        print("1")
                        filter = "Maaş"
                    case 2:
                        print("2")
                        filter = "Yatırım"
                    case 3:
                        print("3")
                        filter = "Ek Gelir"
                    case 4:
                        print("4")
                        filter = "Diğer"
                    default:
                        break
                    }
                    let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                    let fromPred = NSPredicate(format: "%@ < %K && earType CONTAINS '\(filter)'", dateFrom as NSDate, #keyPath(Expent.earDate))
                    let toPred = NSPredicate(format: "%K < %@", #keyPath(Expent.earDate), dateTo1! as NSDate)
                    let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
                    let sort = NSSortDescriptor(key: #keyPath(Expent.earDate), ascending: false)
                    request.sortDescriptors = [sort]
                    request.predicate = datePred
                    expentList = try context.fetch(request)
                    //print(expentList)
                } catch {
                    print(error)
                }
            } else {
                do {
                    let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                    let fromPred = NSPredicate(format: "%@ < %K", dateFrom as NSDate, #keyPath(Expent.earDate))
                    let toPred = NSPredicate(format: "%K < %@", #keyPath(Expent.earDate), dateTo1! as NSDate)
                    let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
                    let sort = NSSortDescriptor(key: #keyPath(Expent.earDate), ascending: false)
                    request.sortDescriptors = [sort]
                    request.predicate = datePred
                    expentList = try context.fetch(request)
                } catch {
                    print(error)
                }
            }
        }
        tableView.reloadData()
    }
}

extension EarningViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expentList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expent = expentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "earningCellID", for: indexPath) as! EarningTableViewCell
        
        cell.nameLabel.text = "\(expent.earName!)"
        cell.costLabel.text = "\(expent.earCost) ₺"
        cell.dateLabel.dateFormatter(label: cell.dateLabel, fromDate: expent.earDate!)
        cell.typeLabel.text = "\(expent.earType!)"
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toEarningDetail", sender: indexPath.row)
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { action, view, boolValue in
            let expent = self.expentList[indexPath.row]
            self.context.delete(expent)
            appDelegate.saveContext()
            self.getFilterEarning(filter: "")
            self.tableView.reloadData()
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "Edit") { action, view, boolValue in
            self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
        }
        
        deleteAction.backgroundColor = .red
        updateAction.backgroundColor = .gray
        
        let swipeAction = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        
        return swipeAction
    }
}
