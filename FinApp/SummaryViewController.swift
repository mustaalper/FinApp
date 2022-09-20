//
//  SummaryViewController.swift
//  FinApp
//
//  Created by MAA on 16.09.2022.
//

import UIKit
import CoreData
import Charts

class SummaryViewController: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext

    var expentListEar = [Expent]()
    var expentListExp = [Expent]()
    
    var ear1 = [Expent]()
    var ear2 = [Expent]()
    var ear3 = [Expent]()
    var ear4 = [Expent]()
    
    var exp1 = [Expent]()
    var exp2 = [Expent]()
    var exp3 = [Expent]()
    var exp4 = [Expent]()
    
    @IBOutlet var pieChart: PieChartView!
    
    var earData = PieChartDataEntry(value: 0.0)
    var expData = PieChartDataEntry(value: 0.0)
    
    var ear1Data = PieChartDataEntry(value: 0.0)
    var ear2Data = PieChartDataEntry(value: 0.0)
    var ear3Data = PieChartDataEntry(value: 0.0)
    var ear4Data = PieChartDataEntry(value: 0.0)
    
    var exp1Data = PieChartDataEntry(value: 0.0)
    var exp2Data = PieChartDataEntry(value: 0.0)
    var exp3Data = PieChartDataEntry(value: 0.0)
    var exp4Data = PieChartDataEntry(value: 0.0)
    
    var selectedDetailIndex = 0
    var selectedDateIndex = 0
    
    
    var numberTotalDataEntries = [PieChartDataEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

    }
    override func viewWillAppear(_ animated: Bool) {
        print("\(selectedDateIndex) ****date")
        print("\(selectedDetailIndex) ----detail")
        switch selectedDetailIndex {
        case 0:
            switch selectedDateIndex {
            case 0:
                getAllDetail()
            case 1:
                getAllWeekDetail()
            case 2:
                getAllMountDetail()
            default:
                break
            }
        case 1:
            switch selectedDateIndex {
            case 0:
                getEarDetail()
            case 1:
                getWeekEarDetail()
            case 2:
                getMountEarDetail()
            default:
                break
            }
        case 2:
            switch selectedDateIndex {
            case 0:
                getExpDetail()
            case 1:
                getWeekExpDetail()
            case 2:
                getMountExpDetail()
            default:
                break
            }
        default:
            break
        }
        //getAllDetail()
    }
    
    func getAllDetail() {
        getAllEar()
        getAllExp()
        var totalEar: Double = 0.0
        for i in 0...expentListEar.count - 1 {
            totalEar += expentListEar[i].earCost
        }
    
        var totalExp: Double = 0.0
        for i in 0...expentListExp.count - 1 {
            totalExp += expentListExp[i].cost
        }
        
        pieChart.chartDescription.text = "Harcama Özeti"
        earData.value = totalEar
        earData.label = "Gelir"
        expData.value = totalExp
        expData.label = "Gider"
        
        numberTotalDataEntries = [earData, expData]
        
        updateChartData()
    }
    
    func getAllWeekDetail() {
        
        var expList = [Expent]()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        let dateTo = calendar.date(byAdding: .day, value: -7, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && earName == nil", nextDate as NSDate, #keyPath(Expent.date))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.date), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            expList = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var earList = [Expent]()
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && name == nil", nextDate as NSDate, #keyPath(Expent.earDate))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.earDate), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            earList = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var totalEar: Double = 0.0
        for i in 0...earList.count - 1 {
            totalEar += earList[i].earCost
        }
        
        var totalExp: Double = 0.0
        for i in 0...expList.count - 1 {
            totalExp += expList[i].cost
        }
        
        pieChart.chartDescription.text = "Haftalık Özet"
        earData.value = totalEar
        earData.label = "Haftalık gelir"
        expData.value = totalExp
        expData.label = "Haftalık gider"
        
        numberTotalDataEntries = [earData, expData]
        
        updateChartData()
    }
    
    func getAllMountDetail() {
        
        var expList = [Expent]()
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        let dateTo = calendar.date(byAdding: .day, value: -30, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && earName == nil", nextDate as NSDate, #keyPath(Expent.date))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.date), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            expList = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var earList = [Expent]()
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && name == nil", nextDate as NSDate, #keyPath(Expent.earDate))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.earDate), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            earList = try context.fetch(request)
        } catch {
            print(error)
        }
        
        var totalEar: Double = 0.0
        for i in 0...earList.count - 1 {
            totalEar += earList[i].earCost
        }
        
        var totalExp: Double = 0.0
        for i in 0...expList.count - 1 {
            totalExp += expList[i].cost
        }
        
        pieChart.chartDescription.text = "Aylık Özet"
        earData.value = totalEar
        earData.label = "Aylık gelir"
        expData.value = totalExp
        expData.label = "Aylık gider"
        
        numberTotalDataEntries = [earData, expData]
        
        updateChartData()
    }
    
    func getEarDetail() {
        getAllEarType(filter: "Maaş", &ear1)
        getAllEarType(filter: "Yatırım", &ear2)
        getAllEarType(filter: "Ek Gelir", &ear3)
        getAllEarType(filter: "Diğer", &ear4)
        
        var totalEar1: Double = 0.0
        if ear1.count != 0 {
            for i in 0...ear1.count - 1 {
                totalEar1 += ear1[i].earCost
            }
        } else {
            totalEar1 = 0.0
        }
        
        
        var totalEar2: Double = 0.0
        if ear2.count != 0 {
            for i in 0...ear2.count - 1 {
                totalEar2 += ear2[i].earCost
            }
        } else {
            totalEar2 = 0.0
        }
        
        
        var totalEar3: Double = 0.0
        if ear3.count != 0 {
            for i in 0...ear3.count - 1 {
                totalEar3 += ear3[i].earCost
            }
        } else {
            totalEar3 = 0.0
        }
        
        var totalEar4: Double = 0.0
        if ear4.count != 0 {
            for i in 0...ear4.count - 1 {
                totalEar4 += ear4[i].earCost
            }
        } else {
            totalEar4 = 0.0
        }
        
        pieChart.chartDescription.text = "Gelir özeti"
        ear1Data.value = totalEar1
        ear1Data.label = "Maaş"
        ear2Data.value = totalEar2
        ear2Data.label = "Yatırım"
        ear3Data.value = totalEar3
        ear3Data.label = "Ek Gelir"
        ear4Data.value = totalEar4
        ear4Data.label = "Diğer"
        numberTotalDataEntries = [ear1Data, ear2Data, ear3Data, ear4Data]
        
        updateChartData1()
    }
    
    func getExpDetail() {
        getAllExpType(filter: "Yemek", &exp1)
        getAllExpType(filter: "Oyun", &exp2)
        getAllExpType(filter: "Fatura", &exp3)
        getAllExpType(filter: "Diğer", &exp4)
        
        var totalExp1: Double = 0.0
        if exp1.count != 0 {
            for i in 0...exp1.count - 1 {
                totalExp1 += exp1[i].cost
            }
        } else {
            totalExp1 = 0.0
        }
        
        var totalExp2: Double = 0.0
        if exp2.count != 0 {
            for i in 0...exp2.count - 1 {
                totalExp2 += exp2[i].cost
            }
        } else {
            totalExp2 = 0.0
        }
        
        var totalExp3: Double = 0.0
        if exp3.count != 0 {
            for i in 0...exp3.count - 1 {
                totalExp3 += exp3[i].cost
            }
        } else {
            totalExp3 = 0.0
        }
        
        var totalExp4: Double = 0.0
        if exp4.count != 0 {
            for i in 0...exp4.count - 1 {
                totalExp4 += exp4[i].cost
            }
        } else {
            totalExp4 = 0.0
        }
        
        pieChart.chartDescription.text = "Gider özeti"
        exp1Data.value = totalExp1
        exp1Data.label = "Yemek"
        exp2Data.value = totalExp2
        exp2Data.label = "Oyun"
        exp3Data.value = totalExp3
        exp3Data.label = "Fatura"
        exp4Data.value = totalExp4
        exp4Data.label = "Diğer"
        numberTotalDataEntries = [exp1Data, exp2Data, exp3Data, exp4Data]
        
        updateChartData2()
    }
    
    func updateChartData() {
        let chartDataSet = PieChartDataSet(entries: numberTotalDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.red, UIColor.blue]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
    }
    
    func updateChartData1() {
        let chartDataSet = PieChartDataSet(entries: numberTotalDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.gray, UIColor.green, UIColor.blue, UIColor.brown]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
    }
    
    func updateChartData2() {
        let chartDataSet = PieChartDataSet(entries: numberTotalDataEntries, label: "")
        let chartData = PieChartData(dataSet: chartDataSet)
        
        let colors = [UIColor.yellow, UIColor.darkGray, UIColor.orange, UIColor.brown]
        chartDataSet.colors = colors
        
        pieChart.data = chartData
    }
    
    func getAllEarType(filter: String, _ typeList: inout [Expent]) {
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let pred = NSPredicate(format: "name == nil && earType CONTAINS '\(filter)'")
            request.predicate = pred
            //var typeList1 = typeList
            typeList = try context.fetch(request)
            //totalEarning(type: filter)
        } catch {
            print(error)
        }
    }
    
    func getAllExpType(filter: String, _ typeList: inout [Expent]) {
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let pred = NSPredicate(format: "earName == nil && type CONTAINS '\(filter)'")
            request.predicate = pred
            //var typeList1 = typeList
            typeList = try context.fetch(request)
            //totalEarning(type: filter)
        } catch {
            print(error)
        }
    }
    
    func getAllEar() {
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            
            let pred = NSPredicate(format: "name == nil")
            request.predicate = pred
            expentListEar = try context.fetch(request)
            //totalCost(list: expentListEar)
        } catch {
            print("error")
        }
    }
    
    func getAllExp() {
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            
            let pred = NSPredicate(format: "earName == nil")
            request.predicate = pred
            expentListExp = try context.fetch(request)
            //totalCost(list: expentListExp)
        } catch {
            print("error")
        }
    }
    
    func getWeekEar(filter: String, _ typeList: inout [Expent]) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        //let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: -7, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && name == nil && earType CONTAINS '\(filter)'", nextDate as NSDate, #keyPath(Expent.earDate))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.earDate), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            typeList = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func getMountEar(filter: String, _ typeList: inout [Expent]) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        //let dateFrom = calendar.startOfDay(for: Date.now)
        let dateTo = calendar.date(byAdding: .day, value: -30, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && name == nil && earType CONTAINS '\(filter)'", nextDate as NSDate, #keyPath(Expent.earDate))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.earDate), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            typeList = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func getWeekExp(filter: String, _ typeList: inout [Expent]) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        //let dateFrom = calendar.startOfDay(for: Date())
        let dateTo = calendar.date(byAdding: .day, value: -7, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && earName == nil && type CONTAINS '\(filter)'", nextDate as NSDate, #keyPath(Expent.date))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.date), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            typeList = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func getMountExp(filter: String, _ typeList: inout [Expent]) {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        var dayComponent = DateComponents()
        dayComponent.day = 1
        let nextDate = calendar.date(byAdding: dayComponent, to: Date())!
        //let dateFrom = calendar.startOfDay(for: Date.now)
        let dateTo = calendar.date(byAdding: .day, value: -30, to: nextDate)
        do {
            let request = Expent.fetchRequest() as NSFetchRequest<Expent>
            let fromPred = NSPredicate(format: "%@ > %K && earName == nil && type CONTAINS '\(filter)'", nextDate as NSDate, #keyPath(Expent.date))
            let toPred = NSPredicate(format: "%K > %@", #keyPath(Expent.date), dateTo! as NSDate)
            let datePred = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPred, toPred])
            request.predicate = datePred
            typeList = try context.fetch(request)
        } catch {
            print(error)
        }
    }
    
    func getMountExpDetail() {
        getMountExp(filter: "Yemek", &exp1)
        getMountExp(filter: "Oyun", &exp2)
        getMountExp(filter: "Fatura", &exp3)
        getMountExp(filter: "Diğer", &exp4)
        
        var totalExp1: Double = 0.0
        if exp1.count != 0 {
            for i in 0...exp1.count - 1 {
                totalExp1 += exp1[i].cost
            }
        } else {
            totalExp1 = 0.0
        }
        
        var totalExp2: Double = 0.0
        if exp2.count != 0 {
            for i in 0...exp2.count - 1 {
                totalExp2 += exp2[i].cost
            }
        } else {
            totalExp2 = 0.0
        }
        
        var totalExp3: Double = 0.0
        if exp3.count != 0 {
            for i in 0...exp3.count - 1 {
                totalExp3 += exp3[i].cost
            }
        } else {
            totalExp3 = 0.0
        }
        
        var totalExp4: Double = 0.0
        if exp4.count != 0 {
            for i in 0...exp4.count - 1 {
                totalExp4 += exp4[i].cost
            }
        } else {
            totalExp4 = 0.0
        }
        
        pieChart.chartDescription.text = "Aylık gider özeti"
        exp1Data.value = totalExp1
        exp1Data.label = "Aylık yemek"
        exp2Data.value = totalExp2
        exp2Data.label = "Aylık oyun"
        exp3Data.value = totalExp3
        exp3Data.label = "Aylık fatura"
        exp4Data.value = totalExp4
        exp4Data.label = "Aylık diğer"
        numberTotalDataEntries = [exp1Data, exp2Data, exp3Data, exp4Data]
        
        updateChartData2()
    }
    
    func getWeekExpDetail() {
        getWeekExp(filter: "Yemek", &exp1)
        getWeekExp(filter: "Oyun", &exp2)
        getWeekExp(filter: "Fatura", &exp3)
        getWeekExp(filter: "Diğer", &exp4)
        
        var totalExp1: Double = 0.0
        if exp1.count != 0 {
            for i in 0...exp1.count - 1 {
                totalExp1 += exp1[i].cost
            }
        } else {
            totalExp1 = 0.0
        }
        
        var totalExp2: Double = 0.0
        if exp2.count != 0 {
            for i in 0...exp2.count - 1 {
                totalExp2 += exp2[i].cost
            }
        } else {
            totalExp2 = 0.0
        }
        
        var totalExp3: Double = 0.0
        if exp3.count != 0 {
            for i in 0...exp3.count - 1 {
                totalExp3 += exp3[i].cost
            }
        } else {
            totalExp3 = 0.0
        }
        
        var totalExp4: Double = 0.0
        if exp4.count != 0 {
            for i in 0...exp4.count - 1 {
                totalExp4 += exp4[i].cost
            }
        } else {
            totalExp4 = 0.0
        }
        
        pieChart.chartDescription.text = "Haftalık gider özeti"
        exp1Data.value = totalExp1
        exp1Data.label = "Haftalık yemek"
        exp2Data.value = totalExp2
        exp2Data.label = "Haftalık oyun"
        exp3Data.value = totalExp3
        exp3Data.label = "Haftalık fatura"
        exp4Data.value = totalExp4
        exp4Data.label = "Haftalık diğer"
        numberTotalDataEntries = [exp1Data, exp2Data, exp3Data, exp4Data]
        
        updateChartData2()
    }
    
    func getMountEarDetail() {
        getMountEar(filter: "Maaş", &ear1)
        getMountEar(filter: "Yatırım", &ear2)
        getMountEar(filter: "Ek Gelir", &ear3)
        getMountEar(filter: "Diğer", &ear4)
        
        var totalEar1: Double = 0.0
        if ear1.count != 0 {
            for i in 0...ear1.count - 1 {
                totalEar1 += ear1[i].earCost
            }
        } else {
            totalEar1 = 0.0
        }
        
        var totalEar2: Double = 0.0
        if ear2.count != 0 {
            for i in 0...ear2.count - 1 {
                totalEar2 += ear2[i].earCost
            }
        } else {
            totalEar2 = 0.0
        }
        
        var totalEar3: Double = 0.0
        if ear3.count != 0 {
            for i in 0...ear3.count - 1 {
                totalEar3 += ear3[i].earCost
            }
        } else {
            totalEar3 = 0.0
        }
        
        var totalEar4: Double = 0.0
        if ear4.count != 0 {
            for i in 0...ear4.count - 1 {
                totalEar4 += ear4[i].earCost
            }
        } else {
            totalEar4 = 0.0
        }
        
        pieChart.chartDescription.text = "Aylık gelir özeti"
        ear1Data.value = totalEar1
        ear1Data.label = "Aylık maaş"
        ear2Data.value = totalEar2
        ear2Data.label = "Aylık yatırım"
        ear3Data.value = totalEar3
        ear3Data.label = "Aylık ek gelir"
        ear4Data.value = totalEar4
        ear4Data.label = "Aylık diğer"
        numberTotalDataEntries = [ear1Data, ear2Data, ear3Data, ear4Data]
        
        updateChartData1()
    }
    
    func getWeekEarDetail() {
        getWeekEar(filter: "Maaş", &ear1)
        getWeekEar(filter: "Yatırım", &ear2)
        getWeekEar(filter: "Ek Gelir", &ear3)
        getWeekEar(filter: "Diğer", &ear4)
        
        var totalEar1: Double = 0.0
        if ear1.count != 0 {
            for i in 0...ear1.count - 1 {
                totalEar1 += ear1[i].earCost
            }
        } else {
            totalEar1 = 0.0
        }
        
        var totalEar2: Double = 0.0
        if ear2.count != 0 {
            for i in 0...ear2.count - 1 {
                totalEar2 += ear2[i].earCost
            }
        } else {
            totalEar2 = 0.0
        }
        
        var totalEar3: Double = 0.0
        if ear3.count != 0 {
            for i in 0...ear3.count - 1 {
                totalEar3 += ear3[i].earCost
            }
        } else {
            totalEar3 = 0.0
        }
        
        var totalEar4: Double = 0.0
        if ear4.count != 0 {
            for i in 0...ear4.count - 1 {
                totalEar4 += ear4[i].earCost
            }
        } else {
            totalEar4 = 0.0
        }
        
        pieChart.chartDescription.text = "Gelir özeti"
        ear1Data.value = totalEar1
        ear1Data.label = "Haftalık maaş"
        ear2Data.value = totalEar2
        ear2Data.label = "Haftalık yatırım"
        ear3Data.value = totalEar3
        ear3Data.label = "Haftalık ek gelir"
        ear4Data.value = totalEar4
        ear4Data.label = "Haftalık diğer"
        numberTotalDataEntries = [ear1Data, ear2Data, ear3Data, ear4Data]
        
        updateChartData1()
    }
    
    
    @IBAction func detailChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            switch selectedDateIndex {
            case 0:
                getAllDetail()
            case 1:
                getAllWeekDetail()
            case 2:
                getAllMountDetail()
            default:
                break
            }
            selectedDetailIndex = 0
        case 1:
            switch selectedDateIndex {
            case 0:
                getEarDetail()
            case 1:
                getWeekEarDetail()
            case 2:
                getMountEarDetail()
            default:
                break
            }
            selectedDetailIndex = 1
        case 2:
            switch selectedDateIndex {
            case 0:
                getExpDetail()
            case 1:
                getWeekExpDetail()
            case 2:
                getMountExpDetail()
            default:
                break
            }
            selectedDetailIndex = 2
        default:
            break
        }
    }
    
    @IBAction func dateChange(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            switch selectedDetailIndex {
            case 0:
                getAllDetail()
                selectedDateIndex = 0
            case 1:
                getEarDetail()
                selectedDateIndex = 1
            case 2:
                getExpDetail()
                selectedDateIndex = 2
            default:
                break
            }
        case 1:
            switch selectedDetailIndex {
            case 0:
                getAllWeekDetail()
                selectedDateIndex = 0
            case 1:
                getWeekEarDetail()
                selectedDateIndex = 1
            case 2:
                getWeekExpDetail()
                selectedDateIndex = 2
            default:
                break
            }
        case 2:
            switch selectedDetailIndex {
            case 0:
                getAllMountDetail()
                selectedDateIndex = 0
            case 1:
                getMountEarDetail()
                selectedDateIndex = 1
            case 2:
                getMountExpDetail()
                selectedDateIndex = 2
            default:
                break
            }
        default:
            break
        }
    }
    
    
}
