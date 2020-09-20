//
//  CarsTableViewController.swift
//  CarsTestApp
//
//  Created by max on 18.09.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import CoreData

class CarsTableViewController: UITableViewController {
    
    // MARK: - Property
    
    var cars: [Car] = []
    var carModel: [CarModel] = []
    
    // MARK: - Outlet
    
    @IBOutlet weak var addNewCarButton: UINavigationItem!

    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        let context = getContext()
        let fetchRequest: NSFetchRequest<Car> = Car.fetchRequest()
        do {
            cars = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        installDefaultValue()
        checkFirstLaunch()
        self.tableView.tableFooterView = UIView()
    }
    
    // MARK: - Private
    
    private func checkFirstLaunch(){
        let defaults = UserDefaults.standard
        
        if let _ = defaults.string(forKey: "isAppAlreadyLaunchedOnce"){
            print("App already launched")
        } else {
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            
            for car in carModel {
                let context = getContext()
                guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
                let carObject = Car(entity: entity, insertInto: context)
                carObject.model = car.model
                carObject.mark = car.mark
                carObject.year = car.year
                carObject.bodyType = car.bodyType
                do {
                    try context.save()
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
        print("App launched first time")
    }
    
    private func installDefaultValue() {
        carModel.append(CarModel(mark: "Toyota", model: "Corolla", year: 2007, bodyType: "Седан"))
        carModel.append(CarModel(mark: "BMW", model: "X6", year: 2015, bodyType: "Кроссовер"))
        carModel.append(CarModel(mark: "Hyundai", model: "Accent", year: 2007, bodyType: "Седан"))
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cars.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? CarTableViewCell {
            
            let car = cars[indexPath.row]
            cell.markLabel.text = car.mark
            cell.modelLabel.text = car.model
            cell.yearLabel.text = "\(car.year)"
            cell.bodyTypeLabel.text = car.bodyType
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let car = cars[indexPath.row]
        if editingStyle == .delete {
            let context = getContext()
            cars.remove(at: indexPath.row)
            context.delete(car)
            do {
                try context.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
    }
}
