//
//  ViewController.swift
//  TodoListTakvim
//
//  Created by Mirhan Mert Yıldız on 25.06.2024.
//

import UIKit
import EventKit

class ViewController: UIViewController {
    var dateFormatter : DateFormatter = DateFormatter()
    let eventStore = EKEventStore()
    var todoEntites: [TodoEntity] = []
    var ekEvents: [EKEvent] = []
    var updatedEntity : TodoEntity!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Takvim Todo Uygulaması"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTodo))
        dateFormatter.dateFormat = "dd.MM.y HH:MM"
        tableView.delegate = self
        tableView.dataSource = self
        fetchEventsFromCalendar()
    }
    
    
    @objc func addTodo() {
        performSegue(withIdentifier: "toCreateTodo", sender: self)
    }

    func fetchEventsFromCalendar() -> Void {
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch status {
            case .notDetermined: requestAccessToCalendar("Calendar")
            case .authorized: fetchEventsFromCalendar("Calendar")
            case .denied: makeAlert(title: "Hata", description: "Lütfen Takvim iznini veriniz.")
            default: break
        }
    }

    func requestAccessToCalendar(_ calendarTitle: String) {
        eventStore.requestAccess(to: EKEntityType.event) { (_, _) in
            self.fetchEventsFromCalendar(calendarTitle)
        }
    }

    func fetchEventsFromCalendar(_ calendarTitle: String) -> Void {
        for calendar in eventStore.calendars(for: .event) {
            if calendar.title == calendarTitle {
                let oneYearAgo = Calendar.current.date(byAdding: .year, value: -4, to: Date()) ?? Date()
                let oneYearAfter = Calendar.current.date(byAdding: .year, value: 4, to: Date()) ?? Date()
                let predicate = eventStore.predicateForEvents(
                    withStart: oneYearAgo,
                    end: oneYearAfter,
                    calendars: [calendar]
                )
                let events = eventStore.events(matching: predicate)
                for event in events {
                    todoEntites.append(TodoEntity(event.eventIdentifier, event.title, event.startDate, event.endDate))
                    ekEvents.append(event)
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdateTodo" {
            if let updateTodoViewController = segue.destination as? TodoUpdateViewController {
                updateTodoViewController.entity = updatedEntity
            }
        }
    }
    
}

extension ViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoEntites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todoEntity = todoEntites[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TodoTableViewCell
        cell.titleLabel.text = todoEntity.title
        cell.startDateLabel.text = dateFormatter.string(from: todoEntity.startDate)
        cell.finishDateLabel.text = dateFormatter.string(from: todoEntity.finishDate)
        cell.controller = self
        cell.todoEntity = todoEntity
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            let ekEvent = ekEvents[indexPath.row]
            todoEntites.remove(at: indexPath.row)
            ekEvents.remove(at: indexPath.row)
            
            do {
                try eventStore.remove(ekEvent, span: .thisEvent)
                tableView.reloadData()
           } catch let error as NSError {
                print("Etkinlik silinemedi: \(error)")
           }
            
        }
        
        
    }
    
    
}

extension UIViewController {
    func makeAlert(title: String, description: String) {
        let alertController = UIAlertController(title: title, message: description, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Tamam", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

