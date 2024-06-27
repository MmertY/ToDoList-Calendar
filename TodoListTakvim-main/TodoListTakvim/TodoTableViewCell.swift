//
//  TodoTableViewCell.swift
//  TodoListTakvim
//
//  Created by Mirhan Mert Yıldız on 25.06.2024.
//

import UIKit

class TodoTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishDateLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    weak var controller : ViewController!
    weak var todoEntity : TodoEntity!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func editButtonClicked(_ sender: Any) {
        controller.updatedEntity = todoEntity
        controller.performSegue(withIdentifier: "toUpdateTodo", sender: self)
    }
}
