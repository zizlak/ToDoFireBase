//
//  TasksViewController.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 25.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import UIKit
import Firebase

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    // MARK: Private values
   private var user: UserT!
   private var ref: DatabaseReference!
   private var tasks: [Task] = []
    
    // MARK: SignOut
    @IBAction func signOutTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
        } catch  {
            print(error.localizedDescription)
        }
        
        dismiss(animated: true, completion:nil)
    }
    
    
    // MARK: ADD
    @IBAction func add(_ sender: UIBarButtonItem) {
        
        let ac = UIAlertController(title: "Add new Task", message: nil, preferredStyle: .alert)
        ac.addTextField()
        let save = UIAlertAction(title: "Save", style: .default) {[weak self]_ in
            
            guard let tf = ac.textFields?.first, let text = tf.text, text != "" else {return}
            let task = Task(title: tf.text!, userID: (self?.user.uid)!)
            let taskRef = self?.ref.child(task.title.lowercased())
            taskRef?.setValue(task.convertToDict())
            
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        ac.addAction(save)
        ac.addAction(cancel)
        present(ac, animated: true)
    }
    
    
    // MARK: TableView
    @IBOutlet var tableView: UITableView?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = tasks[indexPath.row].title
        
        cell.textLabel?.textColor = .white
        
        toggleCompletion(cell, isCompleted: tasks[indexPath.row].completed)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let task = tasks[indexPath.row]
            task.ref?.removeValue()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else {return}
        let task = tasks[indexPath.row]
        let isCompleted = !task.completed
        
        toggleCompletion(cell, isCompleted: isCompleted)
        
        task.ref?.updateChildValues(["completed": isCompleted])
    }
    
    func toggleCompletion(_ cell: UITableViewCell, isCompleted: Bool){
        cell.accessoryType = isCompleted ? .checkmark : .none
    }
    
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.tableFooterView = UIView()
        
        guard let curretnUser = Auth.auth().currentUser else {return}
        user = UserT(user: curretnUser)
        ref = Database.database().reference(withPath: "users").child(user.uid).child("tasks")
    }
    
    // MARK: viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) {[weak self] (snapshot) in
            var _tasks = Array<Task>()
            
            for item in snapshot.children{
                let task = Task(snapshot: item as! DataSnapshot)
                _tasks.append(task)
            }
            self?.tasks = _tasks
            self?.tableView?.reloadData()
        }
    }
    
    // MARK: viewWillDissAppear
    
    override func viewWillDisappear(_ animated: Bool) {
        ref.removeAllObservers()
    }
    
}
