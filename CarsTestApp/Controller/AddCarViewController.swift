//
//  AddCarViewController.swift
//  CarsTestApp
//
//  Created by max on 18.09.2020.
//  Copyright © 2020 Max. All rights reserved.
//

import UIKit
import CoreData

class AddCarViewController: UIViewController {
    
    var car: Car!
    
    @IBOutlet weak var modelTextField: UITextField!
    @IBOutlet weak var markTextField: UITextField!
    @IBOutlet weak var yearTextField: UITextField!
    @IBOutlet weak var bodyTypeTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func addCarButton(_ sender: Any) {
        valideTextField(model: modelTextField, mark: markTextField, year: yearTextField, body: bodyTypeTextField)
    }
   
    
    private func valideTextField(model: UITextField, mark: UITextField, year: UITextField, body: UITextField) {
        if model.text != nil && model.text != "",
            mark.text != nil && mark.text != "",
            year.text != nil && year.text != "",
            body.text != nil && body.text != "" && (Int16(year.text ?? "") != nil){
            saveCar()
            model.text = ""
            mark.text = ""
            year.text = ""
            body.text = ""
        } else {
            let allert = UIAlertController(title: "Ошибка", message: "Введите корректное значение", preferredStyle: .alert)
            let okButton = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            allert.addAction(okButton)
            present(allert, animated: true, completion: nil)
        }
    }
    
    
    private func saveCar() {
        let context = getContext()
        guard let entity = NSEntityDescription.entity(forEntityName: "Car", in: context) else { return }
        let carObject = Car(entity: entity, insertInto: context)
        guard let year = Int16(yearTextField.text ?? "") else { return }
        carObject.model = modelTextField.text
        carObject.mark = markTextField.text
        carObject.year = year
        carObject.bodyType = bodyTypeTextField.text
        do {
            try context.save()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.first != nil {
            view.endEditing(true)
        }       
    }

}
