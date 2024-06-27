//
//  TodoCreateViewController.swift
//  TodoListTakvim
//
//  Created by Mirhan Mert Yıldız on 25.06.2024.
//

import UIKit
import EventKit

class TodoUpdateViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    var entity: TodoEntity!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.text = entity.title
        startDatePicker.date = entity.startDate
        endDatePicker.date = entity.finishDate
    }
    @IBAction func updateButtonClicked(_ sender: Any) {
        if titleTextField.text == nil || titleTextField.text!.isEmpty {
            makeAlert(title: "Hata", description: "Başlığı giriniz.")
            return
        }
        let viewController = navigationController!.viewControllers[0] as? ViewController
        let eventStore = viewController!.eventStore
        let event = eventStore.event(withIdentifier: entity.identifier)!
        event.title = titleTextField.text
        event.startDate = startDatePicker.date
        event.endDate = endDatePicker.date
        do {
            try eventStore.save(event, span: .thisEvent)
            let todoEntity = TodoEntity(event.eventIdentifier, titleTextField.text!, startDatePicker.date, endDatePicker.date)
            let index = (viewController?.todoEntites.firstIndex(where: { $0.identifier == entity.identifier }))!
            viewController?.todoEntites.remove(at: index)
            viewController?.todoEntites.insert(todoEntity, at: index)
            viewController?.tableView.reloadData()
        } catch let error as NSError {
            print("Etkinlik eklenemedi: \(error)")
        }
        navigationController?.popToViewController(viewController!, animated: true)
    }
}
