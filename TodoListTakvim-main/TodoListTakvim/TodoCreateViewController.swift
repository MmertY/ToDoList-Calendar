//
//  TodoCreateViewController.swift
//  TodoListTakvim
//
//  Created by Mirhan Mert Yıldız on 25.06.2024.
//

import UIKit
import EventKit

class TodoCreateViewController: UIViewController {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        if titleTextField.text == nil || titleTextField.text!.isEmpty {
            makeAlert(title: "Hata", description: "Başlığı giriniz.")
            return
        }
        let viewController = navigationController!.viewControllers[0] as? ViewController
        let eventStore = viewController!.eventStore
        let event = EKEvent(eventStore: eventStore)
        event.title = titleTextField.text
        event.startDate = startDatePicker.date
        event.endDate = endDatePicker.date
        event.calendar = eventStore.defaultCalendarForNewEvents
        do {
            try eventStore.save(event, span: .thisEvent)
            let todoEntity = TodoEntity(event.eventIdentifier, titleTextField.text!, startDatePicker.date, endDatePicker.date)
            viewController?.todoEntites.append(todoEntity)
            viewController?.ekEvents.append(event)
            viewController?.tableView.reloadData()
        } catch let error as NSError {
            print("Etkinlik eklenemedi: \(error)")
        }
        navigationController?.popToViewController(viewController!, animated: true)
    }
}
