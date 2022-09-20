//
//  ViewController.swift
//  FinApp
//
//  Created by MAA on 13.09.2022.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class ViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    @IBOutlet var tableView: UITableView!
    @IBOutlet var totalCost: UILabel!
    @IBOutlet var startDate: UITextField!
    @IBOutlet var endDate: UITextField!
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
        getFilterExpent(filter: "")
        tableView.reloadData()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        startDate.inputAccessoryView = toolbar
        startDate.inputView = datePicker
        endDate.inputAccessoryView = toolbar
        endDate.inputView = datePicker1
        datePicker.datePickerMode = .date
        datePicker1.datePickerMode = .date
    }
    
    @objc func donePressed() {
        startDate.dateFormatter(textField: startDate, fromDate: datePicker)
        endDate.dateFormatter(textField: endDate, fromDate: datePicker1)
        self.view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let index = sender as? Int
        if segue.identifier == "toDetail" {
            let destVC = segue.destination as! DetailViewController
            destVC.expent = expentList[index!]
        }
    }
    
    func getFilterExpent(filter: String) {
        do {
            if filter == "" {
                let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                let pred = NSPredicate(format: "earName == nil")
                request.predicate = pred
                let sort = NSSortDescriptor(key: #keyPath(Expent.date), ascending: false)
                request.sortDescriptors = [sort]
                expentList = try context.fetch(request)
                totalExpent(type: "")
                self.addBarButton.isEnabled = true
                self.selectedType = false
            } else {
                let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                let pred = NSPredicate(format: "earName == nil && type CONTAINS '\(filter)'")
                request.predicate = pred
                let sort = NSSortDescriptor(key: #keyPath(Expent.date), ascending: false)
                request.sortDescriptors = [sort]
                expentList = try context.fetch(request)
                totalExpent(type: filter)
                self.addBarButton.isEnabled = false
                self.selectedType = true
            }
        } catch {
            print(error)
        }
    }
    
    func totalExpent(type: String) {
        var total: Double = 0.0
        if expentList.count != 0 {
            for i in 0...expentList.count - 1 {
                total += expentList[i].cost
            }
            if type == "" {
                totalCost.text = "Toplam Gider: \(String(format: "%.2f", total)) ₺"
            } else {
                totalCost.text = "Toplam \(type) : \(String(format: "%.2f", total)) ₺"
            }
        } else {
            totalCost.text = "Toplam \(type) : - ₺"
        }
    }
    
    @IBAction func typeDidChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            getFilterExpent(filter: "")
            selectIndex = 0
        case 1:
            getFilterExpent(filter: "Yemek")
            selectIndex = 1
        case 2:
            getFilterExpent(filter: "Oyun")
            selectIndex = 2
        case 3:
            getFilterExpent(filter: "Fatura")
            selectIndex = 3
        case 4:
            getFilterExpent(filter: "Diğer")
            selectIndex = 4
        default:
            break
        }
        tableView.reloadData()
    }
    
    
    @IBAction func filtreButtonAction(_ sender: Any) {
        if startDate.text?.isEmpty == true || endDate.text?.isEmpty == true {
            print("Hata")
        } else {
            var calendar = Calendar.current
            calendar.timeZone = NSTimeZone.local
            let dateFrom = calendar.startOfDay(for: datePicker.date)
            let dateTo = calendar.startOfDay(for: datePicker1.date)
            let delta = dateFrom.distance(to: dateTo)
            let x = (delta / 86400) + 1
            let dateTo1 = calendar.date(byAdding: .day, value: Int(x), to: dateFrom)
            if selectedType == true {
                do {
                    var filter = ""
                    switch selectIndex {
                    case 0:
                        filter = ""
                    case 1:
                        filter = "Yemek"
                    case 2:
                        filter = "Oyun"
                    case 3:
                        filter = "Fatura"
                    case 4:
                        filter = "Diğer"
                    default:
                        break
                    }
                    let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                    let fromPred = NSPredicate(format: "%@ < %K && type CONTAINS '\(filter)'", dateFrom as NSDate, #keyPath(Expent.date))
                    let toPred = NSPredicate(format: "%K < %@", #keyPath(Expent.date), dateTo1! as NSDate)
                    let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
                    let sort = NSSortDescriptor(key: #keyPath(Expent.earDate), ascending: false)
                    request.sortDescriptors = [sort]
                    request.predicate = datePred
                    expentList = try context.fetch(request)
                } catch {
                    print(error)
                }
            } else {
                do {
                    let request = Expent.fetchRequest() as NSFetchRequest<Expent>
                    let fromPred = NSPredicate(format: "%@ < %K", dateFrom as NSDate, #keyPath(Expent.date))
                    let toPred = NSPredicate(format: "%K < %@", #keyPath(Expent.date), dateTo1! as NSDate)
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

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return expentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expent = expentList[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "expentCellID", for: indexPath) as! TableViewCell
        
        cell.nameLabel.text = "\(expent.name!)"
        cell.costLabel.text = "\(expent.cost)"
        cell.typeLabel.text = "\(expent.type!)"
        cell.dateLabel.dateFormatter(label: cell.dateLabel, fromDate: expent.date!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { action, view, boolValue in
            let expent = self.expentList[indexPath.row]
            self.context.delete(expent)
            appDelegate.saveContext()
            self.getFilterExpent(filter: "")
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

